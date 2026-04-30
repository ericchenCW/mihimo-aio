## Why

需要支持 arm64 架构以覆盖 ARM 服务器（如 AWS Graviton、Oracle Cloud ARM）和 ARM 设备（如树莓派、路由器）等部署场景。

## What Changes

- Dockerfile 使用 `TARGETARCH` 变量动态选择 mihomo binary 架构
- GitHub Actions workflow 添加 QEMU + buildx 支持，构建 linux/amd64 和 linux/arm64 双架构镜像

## Capabilities

### New Capabilities

（无，是对现有能力的修改）

### Modified Capabilities
- `docker-build`: Dockerfile 需要支持多架构构建（通过 TARGETARCH 动态下载对应架构的 mihomo binary）
- `ci-build`: GitHub Actions 需要启用 QEMU 和 buildx，构建并推送多架构 manifest

## Impact

- 修改文件: `Dockerfile`, `.github/workflows/build.yml`
- 构建时间: GitHub Actions 上 arm64 通过 QEMU 模拟，构建时间略有增加
- 镜像产物: 从单架构变为 multi-arch manifest (amd64 + arm64)
