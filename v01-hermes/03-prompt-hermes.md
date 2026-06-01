# Agent 03 — DDD Architecture Prompt (Hermes)

## System Prompt
详见：`/home/admin/.hermes/skills/design-workflow/agents/03-ddd-architecture.md`

## User Prompt
项目名称：苍南二期人事系统

基于 STAGE_1 business_model 和 STAGE_2 industry_insight，执行 DDD 架构设计：
- 从事件流反推子域（核心/支撑/通用）
- 限界上下文划分 + Context Map
- 聚合设计（事务边界+聚合根）
- 领域对象建模（实体/值对象/领域事件/领域服务）
- 反模式检测
- 服务划分 + 通信设计 + 架构模式

关键约束：
- 横切关注点不得独立成限界上下文（审核作为领域服务）
- 表命名需体现 Context 归属（如 pt_/as_/ap_ 等前缀）
- DDD 边界铁律强制执行

输出写入 `/home/admin/.hermes/output/03-result-hermes.md`
