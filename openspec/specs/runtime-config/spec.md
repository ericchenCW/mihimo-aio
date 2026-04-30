## ADDED Requirements

### Requirement: Fetch subscription config on startup
entrypoint.sh SHALL 在容器启动时从环境变量 SUBSCRIBE_URL 指定的地址下载配置文件到 /etc/mihomo/config.yaml。

#### Scenario: Successful subscription fetch
- **WHEN** 容器启动且 SUBSCRIBE_URL 环境变量已设置
- **THEN** 从该 URL 下载内容并保存为 /etc/mihomo/config.yaml

#### Scenario: Missing SUBSCRIBE_URL
- **WHEN** 容器启动但 SUBSCRIBE_URL 环境变量未设置
- **THEN** 输出错误信息并以非零状态码退出

#### Scenario: Download failure
- **WHEN** 容器启动但无法从 SUBSCRIBE_URL 下载配置
- **THEN** 输出错误信息并以非零状态码退出

### Requirement: Override allow-lan to true
entrypoint.sh SHALL 强制将配置文件中的 allow-lan 设置为 true。

#### Scenario: allow-lan field exists in config
- **WHEN** 下载的配置中已包含 allow-lan 字段
- **THEN** 将其值替换为 true

#### Scenario: allow-lan field missing from config
- **WHEN** 下载的配置中不包含 allow-lan 字段
- **THEN** 在配置文件中追加 allow-lan: true

### Requirement: Inject external-ui and external-controller
entrypoint.sh SHALL 在配置中设置 external-ui 为 /etc/mihomo/ui，external-controller 为 0.0.0.0:9090。

#### Scenario: Fields injected into config
- **WHEN** 配置覆写完成
- **THEN** config.yaml 包含 external-ui: /etc/mihomo/ui 和 external-controller: 0.0.0.0:9090

### Requirement: Optional SECRET environment variable
entrypoint.sh SHALL 支持通过 SECRET 环境变量设置 mihomo API 密钥。

#### Scenario: SECRET is set
- **WHEN** SECRET 环境变量已设置
- **THEN** config.yaml 中 secret 字段被设为该值

#### Scenario: SECRET is not set
- **WHEN** SECRET 环境变量未设置
- **THEN** config.yaml 中不添加 secret 字段（或保留订阅配置中的原值）

### Requirement: Hourly config refresh with hot reload
entrypoint.sh SHALL 启动一个后台循环，每 3600 秒重新拉取订阅、覆写配置并调用 mihomo API 热重载。

#### Scenario: Automatic refresh cycle
- **WHEN** 容器运行超过 1 小时
- **THEN** 后台循环重新下载订阅、应用覆写，并通过 PUT /configs?force=true API 触发 mihomo 重载配置

#### Scenario: Refresh failure does not crash container
- **WHEN** 定时刷新时订阅 URL 不可达
- **THEN** mihomo 继续使用上一次的有效配置运行，后台循环继续尝试下一次刷新

### Requirement: mihomo runs as PID 1
entrypoint.sh SHALL 使用 exec 启动 mihomo，确保其作为容器 PID 1 运行，正确处理信号。

#### Scenario: Process as PID 1
- **WHEN** 容器完全启动
- **THEN** mihomo 进程 PID 为 1，能正确响应 SIGTERM 实现优雅停止
