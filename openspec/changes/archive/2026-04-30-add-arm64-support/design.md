## Context

当前 Dockerfile 硬编码 `mihomo-linux-amd64`，GitHub Actions 仅构建 linux/amd64 平台。

## Goals / Non-Goals

**Goals:**
- Dockerfile 通过 TARGETARCH 自动适配 amd64/arm64
- GitHub Actions 使用 QEMU + buildx 构建双架构镜像并推送 multi-arch manifest

**Non-Goals:**
- 不支持其他架构 (armv7, s390x 等)

## Decisions

### 1. 使用 Docker TARGETARCH 自动变量

**选择**: `ARG TARGETARCH` + 拼接下载 URL
**理由**: BuildKit 原生支持，mihomo release 命名格式恰好匹配 (`mihomo-linux-{amd64|arm64}-version.gz`)，无需额外映射。

### 2. QEMU 交叉构建

**选择**: `docker/setup-qemu-action` + `docker/setup-buildx-action`
**理由**: GitHub Actions runner 仅有 x86，需要 QEMU 模拟 arm64。此镜像构建过程无编译步骤（仅下载和复制），QEMU 性能开销极小。
