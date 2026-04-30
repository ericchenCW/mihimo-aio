## 1. Dockerfile 多架构支持

- [x] 1.1 添加 ARG TARGETARCH，将 mihomo 下载 URL 中的 amd64 替换为 ${TARGETARCH}

## 2. GitHub Actions 多架构构建

- [x] 2.1 添加 docker/setup-qemu-action 步骤
- [x] 2.2 添加 docker/setup-buildx-action 步骤
- [x] 2.3 修改 platforms 为 linux/amd64,linux/arm64
