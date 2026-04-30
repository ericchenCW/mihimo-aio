## Context

为 mihomo-aio 项目编写 README.md，同时服务人类和 LLM Agent。

## Goals / Non-Goals

**Goals:**
- Human 部分：简洁的快速开始、环境变量表、端口表
- Agent 部分：嵌入式 prompt，定义问答流程，收集 SUBSCRIBE_URL / SECRET / 端口 后生成 docker run 命令

**Non-Goals:**
- 不覆盖 docker-compose、k8s 等进阶部署
- 不做详细的 mihomo 配置教程

## Decisions

### Agent 指引格式

**选择**: 用自然语言描述问答流程 + 命令模板
**理由**: 对各种 LLM 通用（不依赖特定 agent 框架），任何能读 markdown 的 AI 都能理解并执行。
