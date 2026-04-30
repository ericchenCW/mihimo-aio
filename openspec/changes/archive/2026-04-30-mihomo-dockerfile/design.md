## Context

全新项目，需要构建一个 mihomo all-in-one Docker 镜像。目标是让用户只需提供订阅 URL 即可一键启动代理服务，内置 Web 管理面板。目标平台 linux/amd64。

## Goals / Non-Goals

**Goals:**
- 构建时下载所有必要组件（mihomo binary、geo 数据、Web 面板），镜像自包含
- 运行时通过环境变量注入订阅 URL，零配置文件挂载
- 强制覆写 `allow-lan: true` 使容器可作为局域网代理
- 内置 metacubexd 面板，通过 mihomo 原生 `external-ui` 功能提供
- 每小时自动刷新订阅，通过 mihomo API 热重载

**Non-Goals:**
- 不支持多架构构建（仅 amd64）
- 不暴露 DNS/TProxy/TUN 功能
- 不提供 nginx/caddy 等额外 Web 服务器
- 不做配置模板/规则管理，所有规则来自订阅

## Decisions

### 1. 基础镜像: alpine

**选择**: alpine
**理由**: 最小化镜像体积（~5MB base），且提供 curl 等运行时工具。mihomo 是静态编译的 Go 程序，无 glibc 依赖问题。

### 2. 面板: metacubexd

**选择**: metacubexd (MetaCubeX 官方面板)
**备选**: yacd-meta, Zashboard
**理由**: 官方维护，功能最全，与 mihomo 兼容性最好。通过 `external-ui` 原生提供，无需额外 Web 服务器。

### 3. 配置覆写方式: sed

**选择**: 使用 sed 进行文本替换
**备选**: yq (YAML 工具)
**理由**: 零额外依赖，alpine 内置 sed。只需覆写几个顶级字段（allow-lan, external-ui, external-controller, secret），sed 完全胜任。

### 4. 定时刷新: 后台 shell 循环

**选择**: `while sleep 3600; do ... done &` 后台循环
**备选**: crond
**理由**: 不需要额外进程管理器，mihomo 保持 PID 1（正确接收信号）。循环在后台运行，容器退出时自动终止。

### 5. 热重载: mihomo RESTful API

**选择**: `PUT /configs?force=true` 触发重载
**理由**: mihomo 原生支持，无需重启进程，代理连接不中断。

### 6. Geo 数据来源: MetaCubeX/meta-rules-dat

**选择**: 从 MetaCubeX/meta-rules-dat GitHub Release 下载
**理由**: 官方维护的规则数据，与 mihomo 完全兼容，定期更新。

## Risks / Trade-offs

- **[订阅 URL 不可达]** → entrypoint 应在 curl 失败时输出明确错误并退出，避免 mihomo 启动无配置
- **[sed 覆写不完美]** → 仅处理顶级字段，对嵌套 YAML 不做处理。如果订阅配置格式异常可能失败，但主流订阅服务输出格式标准
- **[GitHub Release 下载限速]** → 构建时下载，不影响运行时。可通过 mirror 或 proxy 解决
- **[镜像更新 geo 数据]** → geo 数据固化在镜像中，需重新构建镜像更新。可接受，因为 geo 数据变更不频繁
