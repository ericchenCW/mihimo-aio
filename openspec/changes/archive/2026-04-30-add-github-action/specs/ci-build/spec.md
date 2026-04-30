## ADDED Requirements

### Requirement: Manual trigger builds Docker image
GitHub Actions workflow SHALL 支持通过 workflow_dispatch 手动触发，构建 linux/amd64 Docker 镜像。

#### Scenario: Manual trigger via GitHub UI
- **WHEN** 用户在 GitHub Actions 页面点击 "Run workflow"
- **THEN** workflow 执行 docker build 构建 linux/amd64 镜像

### Requirement: Push image to GHCR
Workflow SHALL 将构建完成的镜像推送到 GitHub Container Registry (ghcr.io)。

#### Scenario: Successful push
- **WHEN** docker build 成功完成
- **THEN** 镜像被推送到 ghcr.io/<owner>/<repo> 并附带 latest 和日期 tag

### Requirement: Authenticate with GITHUB_TOKEN
Workflow SHALL 使用内置 GITHUB_TOKEN 进行 GHCR 鉴权，无需额外 secrets。

#### Scenario: Authentication
- **WHEN** workflow 执行 docker login
- **THEN** 使用 secrets.GITHUB_TOKEN 登录 ghcr.io

### Requirement: Tag with latest and date
构建的镜像 SHALL 同时标记 `latest` tag 和当天日期 tag (YYYY-MM-DD 格式)。

#### Scenario: Image tags
- **WHEN** 镜像推送到 GHCR
- **THEN** 镜像同时具有 `latest` 和 `YYYY-MM-DD` 格式的 tag
