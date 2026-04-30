## ADDED Requirements

### Requirement: Human-readable quick start section
README SHALL 包含面向人类的快速开始部分，包括一行 docker run 示例命令。

#### Scenario: User reads quick start
- **WHEN** 用户打开 README.md
- **THEN** 能看到完整的 docker run 示例命令、环境变量表和端口表

### Requirement: LLM Agent interactive guide
README SHALL 包含面向 LLM Agent 的结构化指引，定义问答流程。

#### Scenario: Agent reads and executes guide
- **WHEN** LLM Agent 读取 README 的 agent 部分
- **THEN** Agent 能按流程向用户提问（订阅URL、密钥、端口），并根据回答生成正确的 docker run 命令

### Requirement: Agent generates valid docker run command
Agent 指引 SHALL 包含命令模板，确保生成的 docker run 命令语法正确且包含所有必要参数。

#### Scenario: Complete command generation
- **WHEN** Agent 收集完所有必要信息
- **THEN** 输出的 docker run 命令包含 -e SUBSCRIBE_URL、-p 端口映射，且可选包含 -e SECRET
