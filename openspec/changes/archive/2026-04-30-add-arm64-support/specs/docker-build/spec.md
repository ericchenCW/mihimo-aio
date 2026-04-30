## MODIFIED Requirements

### Requirement: Fetch subscription config on startup
Dockerfile SHALL 使用 TARGETARCH 构建参数动态选择 mihomo binary 下载 URL，支持 amd64 和 arm64 两种架构。

#### Scenario: Build for amd64
- **WHEN** 构建目标平台为 linux/amd64
- **THEN** 下载 mihomo-linux-amd64-{version}.gz

#### Scenario: Build for arm64
- **WHEN** 构建目标平台为 linux/arm64
- **THEN** 下载 mihomo-linux-arm64-{version}.gz
