## Why

需要一个开箱即用的 mihomo 代理 Docker 镜像，通过环境变量注入订阅 URL 即可运行，内置 Web 管理面板，免去手动配置 geo 数据和面板的繁琐步骤。

## What Changes

- 新增 Dockerfile，基于 alpine 多阶段构建，构建时下载 mihomo 二进制、geo 数据文件和 Web 面板
- 新增 entrypoint.sh 启动脚本，处理订阅拉取、配置覆写和定时刷新
- 容器通过环境变量 `SUBSCRIBE_URL` 注入订阅地址，`SECRET` 设置 API 密钥
- 配置强制覆写 `allow-lan: true`，注入 `external-ui` 和 `external-controller`
- 每小时自动重新拉取订阅并通过 mihomo API 热重载，零中断

## Capabilities

### New Capabilities
- `docker-build`: Dockerfile 多阶段构建，下载 mihomo binary、geo 数据 (GeoIP.dat, GeoSite.dat, country.mmdb) 和 metacubexd 面板
- `runtime-config`: 容器启动时拉取订阅、覆写配置字段、定时刷新和热重载机制

### Modified Capabilities

（无，全新项目）

## Impact

- 新增文件: `Dockerfile`, `entrypoint.sh`
- 外部依赖: MetaCubeX/mihomo (binary), MetaCubeX/meta-rules-dat (geo data), MetaCubeX/metacubexd (web panel)
- 网络端口: 7890 (HTTP), 7891 (SOCKS), 7893 (Mixed), 9090 (API + UI)
