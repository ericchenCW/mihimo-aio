## Context

项目已有 Dockerfile 用于构建 mihomo all-in-one 镜像 (linux/amd64)。现需添加 CI 自动构建并推送到 GHCR。

## Goals / Non-Goals

**Goals:**
- 手动触发 (workflow_dispatch) 构建镜像
- 推送到 ghcr.io，使用 GITHUB_TOKEN 鉴权
- 镜像 tag 使用 `latest` + 构建日期 (如 `2026-04-30`)

**Non-Goals:**
- 不做多架构构建 (仅 amd64)
- 不做自动触发 (不绑定 push/tag 事件)
- 不做镜像扫描或测试步骤

## Decisions

### 1. 使用 docker/build-push-action

**选择**: 官方 `docker/build-push-action` + `docker/login-action`
**理由**: 社区标准方案，缓存支持好，文档完善。

### 2. 镜像 Tag 策略

**选择**: 同时打 `latest` 和日期 tag (`YYYY-MM-DD`)
**理由**: `latest` 方便拉取最新版，日期 tag 可回溯历史版本。

### 3. 鉴权方式

**选择**: `GITHUB_TOKEN` (自动提供)
**理由**: 无需手动配置 secrets，仓库内置 token 即可推送到 GHCR。需要 `packages: write` 权限声明。

## Risks / Trade-offs

- **[GitHub API 限流]** → 构建时 Dockerfile 内下载 GitHub Release 可能受限。如频繁触发可考虑缓存层，但手动触发场景下不太可能触发限流。
