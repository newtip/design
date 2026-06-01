# Agent 01 — 需求提炼 Prompt (Hermes)

## System Prompt
详见文件：`/home/admin/.hermes/skills/design-workflow/agents/01-requirement-refinement.md`

## User Prompt

**项目名称**：苍南二期人事系统

**解析后的需求文档**：`/home/admin/.hermes/output/hr-system-parsed.md`（566段落，19张表，完整Markdown）

**完整性报告**：
- document_format: docx
- paragraph_count: 566 (non-empty)
- table_count: 19
- tables_fully_extracted: true
- overall_completeness: complete

**任务**：
按照 01-Requirement Refinement Agent 的完整指令执行需求提炼。输出 business_model YAML，包含：
- Channel A：事件风暴（Commands、Events、Policies、Event Flows、Capability Map）
- Channel B：结构化需求（Functions、Actors、Entities、Fields、Workflows、Business Rules、Integrations、Constraints）
- 双向绑定矩阵
- 痛点、开放问题、覆盖率自检
- 原文锚点

将输出结果写入 `/home/admin/.hermes/output/01-result-hermes.md`
