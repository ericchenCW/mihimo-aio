FROM alpine AS builder
ARG TARGETARCH

RUN apk add --no-cache curl tar gzip

# Download mihomo binary (latest release)
# Use amd64-compatible variant for broader CPU compatibility (no v3 microarchitecture requirement)
RUN MIHOMO_URL=$(curl -sL -o /dev/null -w '%{url_effective}' https://github.com/MetaCubeX/mihomo/releases/latest) && \
    VERSION=$(basename "$MIHOMO_URL") && \
    if [ "$TARGETARCH" = "amd64" ]; then ARCH="amd64-compatible"; else ARCH="$TARGETARCH"; fi && \
    curl -sL "https://github.com/MetaCubeX/mihomo/releases/download/${VERSION}/mihomo-linux-${ARCH}-${VERSION}.gz" -o /tmp/mihomo.gz && \
    gunzip /tmp/mihomo.gz && \
    chmod +x /tmp/mihomo

# Download geo data files
RUN curl -sL "https://github.com/MetaCubeX/meta-rules-dat/releases/latest/download/GeoIP.dat" -o /tmp/GeoIP.dat && \
    curl -sL "https://github.com/MetaCubeX/meta-rules-dat/releases/latest/download/GeoSite.dat" -o /tmp/GeoSite.dat && \
    curl -sL "https://github.com/MetaCubeX/meta-rules-dat/releases/latest/download/country.mmdb" -o /tmp/country.mmdb

# Download metacubexd web panel
RUN curl -sL "https://github.com/MetaCubeX/metacubexd/releases/latest/download/compressed-dist.tgz" -o /tmp/ui.tgz && \
    mkdir -p /tmp/ui && \
    tar -xzf /tmp/ui.tgz -C /tmp/ui

# Final image
FROM alpine

RUN apk add --no-cache curl ca-certificates

COPY --from=builder /tmp/mihomo /usr/local/bin/mihomo
COPY --from=builder /tmp/GeoIP.dat /etc/mihomo/GeoIP.dat
COPY --from=builder /tmp/GeoSite.dat /etc/mihomo/GeoSite.dat
COPY --from=builder /tmp/country.mmdb /etc/mihomo/country.mmdb
COPY --from=builder /tmp/ui /etc/mihomo/ui

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7890 7891 7893 9090

ENTRYPOINT ["/entrypoint.sh"]
