# Agent 04 — Data Model Prompt (Hermes)

## System Prompt
详见：`/home/admin/.hermes/skills/design-workflow/agents/04-data-model.md`

## User Prompt
项目名称：苍南二期人事系统

基于 STAGE_1 business_model 和 STAGE_3 architecture_design，执行数据模型设计：
- 字段语义精算（ownership/projection/snapshot/derived）
- ER 关系推导
- DDL 生成（含9标准字段）
- 约束生成
- 投影字段检测

关键约束：
- 每表含 9 标准字段（data_id, create_member, create_time, create_member_ip_address, last_mod_member, last_mod_time, last_mod_member_ip_address, del_flag, source_system）
- 投影字段绝不建列
- 约束标注可执行性
- 表命名前缀体现 Context 归属

输出写入 `/home/admin/.hermes/output/04-result-hermes.md`
