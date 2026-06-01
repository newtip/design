# STAGE_2: Industry Insight Agent Prompt

已完整加载自 `agents/02-industry-insight.md`（14305 bytes），核心内容包括：

- 项目类型识别：approval_workflow / work_order / ledger_management 等
- 行业模式匹配：审批闭环/培训管理/多租户隔离/容量管理/智能填充
- 需求成熟度评估（0-100分，<50触发门控）
- 增强建议分级：confirmed_by_requirement / recommended_not_confirmed / assumption_for_review / question_only
- 异常边界补充（按FLOW逐一分析）
- 设计决策待办（decision_backlog）
- 知识库检索与路由

完整 Prompt 可通过 `skill_view('design-workflow', 'agents/02-industry-insight.md')` 查看。