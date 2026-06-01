# STAGE_4: Data Model Agent Prompt

已完整加载自 `agents/04-data-model.md`（9430 bytes），核心内容包括：

- 字段语义5分类：ownership / foreign_reference / projection / snapshot / derived
- 9标准字段 (data_id, create_member, create_time, create_member_ip_address, last_mod_member, last_mod_time, last_mod_member_ip_address, del_flag, source_system)
- 投影字段绝不建列（标注JOIN路径）
- ER关系推导 + DDL生成
- 约束可执行性标注

完整 Prompt 可通过 `skill_view('design-workflow', 'agents/04-data-model.md')` 查看。