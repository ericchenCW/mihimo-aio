#!/bin/sh

CONFIG_DIR="/etc/mihomo"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"
API_URL="http://127.0.0.1:9090"

# Fetch subscription and save as config
fetch_config() {
    curl -sL "$SUBSCRIBE_URL" -o "$CONFIG_FILE"
    if [ $? -ne 0 ] || [ ! -s "$CONFIG_FILE" ]; then
        return 1
    fi
    return 0
}

# Override config fields
patch_config() {
    # Ensure file ends with newline before patching
    sed -i -e '$a\' "$CONFIG_FILE"

    # allow-lan: true
    if grep -q '^allow-lan:' "$CONFIG_FILE"; then
        sed -i 's/^allow-lan:.*/allow-lan: true/' "$CONFIG_FILE"
    else
        echo 'allow-lan: true' >> "$CONFIG_FILE"
    fi

    # external-ui
    if grep -q '^external-ui:' "$CONFIG_FILE"; then
        sed -i 's|^external-ui:.*|external-ui: /etc/mihomo/ui|' "$CONFIG_FILE"
    else
        echo 'external-ui: /etc/mihomo/ui' >> "$CONFIG_FILE"
    fi

    # external-controller
    if grep -q '^external-controller:' "$CONFIG_FILE"; then
        sed -i 's/^external-controller:.*/external-controller: 0.0.0.0:9090/' "$CONFIG_FILE"
    else
        echo 'external-controller: 0.0.0.0:9090' >> "$CONFIG_FILE"
    fi

    # secret (only if SECRET env is set)
    if [ -n "$SECRET" ]; then
        if grep -q '^secret:' "$CONFIG_FILE"; then
            sed -i "s/^secret:.*/secret: \"$SECRET\"/" "$CONFIG_FILE"
        else
            echo "secret: \"$SECRET\"" >> "$CONFIG_FILE"
        fi
    fi
}

# Refresh loop: re-fetch and hot reload every hour
refresh_loop() {
    while sleep 3600; do
        echo "[refresh] Fetching subscription..."
        if fetch_config; then
            patch_config
            curl -sX PUT "${API_URL}/configs?force=true" \
                -H "Content-Type: application/json" \
                -d "{\"path\":\"${CONFIG_FILE}\"}" > /dev/null
            echo "[refresh] Config reloaded successfully"
        else
            echo "[refresh] Failed to fetch subscription, keeping current config"
        fi
    done
}

# --- Main ---

if [ -z "$SUBSCRIBE_URL" ]; then
    echo "ERROR: SUBSCRIBE_URL environment variable is required"
    exit 1
fi

echo "Fetching subscription config..."
if ! fetch_config; then
    echo "ERROR: Failed to download config from SUBSCRIBE_URL"
    exit 1
fi

patch_config
echo "Config ready. Starting mihomo..."

# Start refresh loop in background
refresh_loop &

# Start mihomo as PID 1
exec mihomo -d "$CONFIG_DIR"
