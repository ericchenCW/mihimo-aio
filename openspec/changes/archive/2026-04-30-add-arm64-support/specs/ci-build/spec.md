## MODIFIED Requirements

### Requirement: Manual trigger builds Docker image
GitHub Actions workflow SHALL 构建 linux/amd64 和 linux/arm64 双架构镜像，并推送 multi-arch manifest 到 GHCR。

#### Scenario: Multi-arch build
- **WHEN** 用户手动触发 workflow
- **THEN** 构建 linux/amd64 和 linux/arm64 两个平台的镜像，推送为 multi-arch manifest
