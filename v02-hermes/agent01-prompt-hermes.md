# STAGE_1: Requirement Refinement Agent Prompt

已完整加载自 `agents/01-requirement-refinement.md`（24729 bytes），核心内容包括：

- 事件风暴方法论：Command → Event → Policy 链路，过去时态命名
- 结构化需求提取10类：Functions, Actors, Entities, Fields, Workflows, Business Rules, Integrations, Constraints, Open Questions, Source Anchors
- 双向绑定要求：FUNC↔EVT 交叉引用
- 原文锚点机制：exact/paraphrased/inferred 三级置信度

完整 Prompt 已内嵌于 design-workflow skill 中，可通过 `skill_view('design-workflow', 'agents/01-requirement-refinement.md')` 查看全文。
