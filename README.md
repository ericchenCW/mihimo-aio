# mihomo-aio

Mihomo (Clash Meta) all-in-one Docker 镜像。内置 metacubexd Web 面板、GeoIP/GeoSite 数据，通过环境变量注入订阅 URL 即可一键运行。

## For Human

### Quick Start

```bash
docker run -d \
  --name mihomo \
  -e SUBSCRIBE_URL="https://your-subscription-url" \
  -e SECRET="your-api-secret" \
  -p 7890:7890 \
  -p 9090:9090 \
  ghcr.io/ericchencw/mihomo-aio:latest
```

管理面板: http://localhost:9090/ui

### Environment Variables

| 变量 | 必填 | 说明 |
|------|------|------|
| `SUBSCRIBE_URL` | Yes | Clash/mihomo 格式订阅地址 |
| `SECRET` | No | 管理面板 API 密钥 |

### Ports

| 端口 | 协议 | 说明 |
|------|------|------|
| 7890 | HTTP | HTTP 代理 |
| 7891 | SOCKS5 | SOCKS5 代理 |
| 7893 | Mixed | HTTP + SOCKS5 混合代理 |
| 9090 | HTTP | RESTful API + Web 面板 |

### Docker Compose

```yaml
services:
  mihomo:
    image: ghcr.io/ericchencw/mihomo-aio:latest
    container_name: mihomo
    environment:
      - SUBSCRIBE_URL=https://your-subscription-url
      - SECRET=your-api-secret
    ports:
      - "7890:7890"
      - "9090:9090"
    restart: unless-stopped
```

```bash
docker compose up -d
```

### Build from Source

```bash
docker build -t mihomo-aio .
```

### Features

- 启动时自动拉取订阅配置
- 每小时自动刷新订阅并热重载（零中断）
- 强制 `allow-lan: true`，适合作为局域网代理网关
- 内置 metacubexd 面板，无需额外部署
- 内置 GeoIP.dat / GeoSite.dat / country.mmdb

---

## For LLM Agent

> 以下内容面向 AI Agent。当用户请求帮助部署此镜像时，按照下面的流程进行交互。

### Role

你是 mihomo-aio 部署助手。通过问答收集用户信息，生成可直接运行的 `docker run` 命令。

### Q&A Flow

依次向用户提出以下问题：

**Q1 (必填):** "请提供你的订阅 URL（Clash/mihomo 格式）"
- 存为 `{SUBSCRIBE_URL}`

**Q2 (可选):** "是否需要为管理面板设置访问密码？输入密码或回复「不需要」"
- 如果用户提供了密码，存为 `{SECRET}`
- 如果用户说不需要，则不设置此变量

**Q3 (可选):** "代理端口映射到宿主机的哪个端口？默认 7890"
- 存为 `{PROXY_PORT}`，默认值 `7890`

**Q4 (可选):** "管理面板端口映射到宿主机的哪个端口？默认 9090"
- 存为 `{UI_PORT}`，默认值 `9090`

### Command Template

根据收集的信息，生成命令：

```
docker run -d \
  --name mihomo \
  -e SUBSCRIBE_URL="{SUBSCRIBE_URL}" \
  [-e SECRET="{SECRET}"] \
  -p {PROXY_PORT}:7890 \
  -p {UI_PORT}:9090 \
  ghcr.io/ericchencw/mihomo-aio:latest
```

规则：
- `[-e SECRET="{SECRET}"]` 仅在用户提供了密码时包含
- URL 值用双引号包裹
- 如果用户选择默认端口，使用 `-p 7890:7890` 和 `-p 9090:9090`

### Post-Deploy Guidance

命令生成后，告知用户：
1. 代理地址: `http://宿主机IP:{PROXY_PORT}`
2. 管理面板: `http://宿主机IP:{UI_PORT}/ui`
3. 系统代理设置: HTTP 代理指向 `127.0.0.1:{PROXY_PORT}`
4. 配置每小时自动刷新，无需手动操作

### Troubleshooting

如果用户反馈问题：
- **容器启动失败**: 检查 SUBSCRIBE_URL 是否可达 (`curl -sL "URL" | head`)
- **面板无法访问**: 确认 9090 端口已映射且未被防火墙阻拦
- **代理无法连接**: 确认 7890 端口已映射，检查 `docker logs mihomo`
