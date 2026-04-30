## Why

需要通过 CI/CD 自动化构建 Docker 镜像并推送到 GHCR，方便部署时直接拉取预构建镜像，无需在目标机器上本地构建。

## What Changes

- 新增 GitHub Actions workflow 文件，支持手动触发 (workflow_dispatch) 构建 linux/amd64 镜像
- 构建完成后自动推送到 ghcr.io
- 使用 GITHUB_TOKEN 鉴权，零额外 secrets 配置

## Capabilities

### New Capabilities
- `ci-build`: GitHub Actions workflow，手动触发构建 x86_64 Docker 镜像并推送到 GHCR

### Modified Capabilities

（无）

## Impact

- 新增文件: `.github/workflows/build.yml`
- 依赖服务: GitHub Actions, GitHub Container Registry (GHCR)
- 需要仓库开启 packages 写入权限（默认已启用）
