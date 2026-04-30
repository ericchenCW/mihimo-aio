## Why

项目缺少文档。需要一个 README.md 同时服务两类读者：人类用户和 LLM Agent。LLM Agent 部分作为嵌入式 prompt，使任何 AI 工具读到 repo 后能交互式帮用户生成 `docker run` 命令。

## What Changes

- 新增 README.md，包含两个主要部分：
  - **For Human**: 项目简介、快速开始、环境变量、端口说明、构建方式
  - **For LLM Agent**: 结构化的问答流程指引，引导 agent 收集信息并生成 docker run 命令

## Capabilities

### New Capabilities
- `readme-doc`: README.md 文档，包含人类可读说明和 LLM Agent 交互指引

### Modified Capabilities

（无）

## Impact

- 新增文件: `README.md`
- 无代码变更
