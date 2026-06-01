# Agent 05+06 — Prompt (Hermes)

## System Prompt (STAGE_5)
详见：`/home/admin/.hermes/skills/design-workflow/agents/05-design-synthesis.md`

## System Prompt (STAGE_6)
详见：`/home/admin/.hermes/skills/design-workflow/agents/06-solution-writer.md`

## User Prompt
项目名称：苍南二期人事系统

基于全部前序输出（STAGE_1-4），执行设计综合+概设输出：
- 识别设计主线、产品结构策略、体验策略
- 形成设计取舍和Writer表达策略
- 按AE标准9章撰写概设文档
- 输出附录A事件清单+附录B生成记录

关键约束：
- 不捏造需求
- 投影字段标注来源
- 行业建议显式标注（✅⚠️🔶❓）
- 15%工作量缓冲

输出写入 `/home/admin/.hermes/output/05-result-hermes.md`（设计综合概要）
输出写入 `/home/admin/.hermes/output/06-result-hermes.md`（完整9章概设）
