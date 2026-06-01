---
name: design-workflow
description: DDD+AE 融合概要设计 Skill。7 Agent 融合了 ddd-solution 的事件驱动建模能力与 ae-design 的 9 章概设交付能力。支持直通模式 (auto) 和审阅模式 (review) 双模式编排。V1.4 新增聚合粒度指引、成熟度5维评估、异常场景枚举、策略业务化、表命名前缀。
---

# Design Workflow Skill — DDD + AE 融合概设引擎 V1.4

## 定位

**不是"DDD 独立建模"，不是"AE 表单生成"，而是两者的融合引擎。**

V1.4 新增（基于 OpenClaw V1.3 × Hermes V2.0 互评驱动）：
- 聚合粒度指引（small-aggregates-first 原则 + 4级拆分信号）
- 成熟度5维标准化评估（业务完整性/数据确定性/流程清晰度/角色明确性/集成明确性）
- 第3章异常场景独立枚举（E1-E1n格式）
- 策略描述业务化（禁止UI行为/技术术语替代业务规则）
- 表命名前缀规范（Context前缀 + 命名模板）

```
ddd-solution 强项：事件驱动建模、行业经验增强、边界推理
ae-design 强项：UseCase 语义完整性、字段归属精算、9 章交付

融合：
  文档解析(防截断) → 业务事件推理 → 行业增强 → DDD 的 Context + 聚合 + 服务 → 设计综合 → AE 的数据语义 + DDL + 9 章概设
```

## 核心能力

| 维度 | 来源 | 说明 |
|------|------|------|
| 文档解析 | 新增 ⭐V1.2 | Word/表格完整提取 + 完整性自检 + 截断标记 |
| 事件风暴 | ddd-solution | 从业务事件反推 Command → Policy → Aggregate |
| 行业经验增强 | ddd-solution + ae-design ⭐V1.3 | 语义搜索知识库 + 行业模式匹配、需求成熟度评估、决策待办 |
| 领域划分 + BC | ddd-solution | 事件流聚类 → 子域识别 → 限界上下文 |
| 聚合 + 架构 | ddd-solution ⭐V1.4 | small-aggregates-first 原则 → 事务一致性推导 → 服务划分 → 通信设计 |
| 设计综合 | ae-design | 设计意图识别 → 产品结构策略 → 体验策略 → Writer 表达指导 |
| 字段归属 + 投影 | ae-design | ownership/projection/snapshot/derived 四类语义 |
| DDL 生成 | ae-design ⭐V1.4 | 表命名前缀 + 投影不建列、约束自动生成 |
| 9 章概设 | ae-design ⭐V1.4 | AE 标准 9 章结构 + 异常场景枚举 + 成熟度5维 |

---

## 一、架构总览

```
┌──────────────────────────────────────────────────────────────────────┐
│              Orchestrator（双模式编排层 + Preflight）                   │
│  mode: auto | review                                                 │
│  preflight_check → architecture_memory + smart_state_machine          │
│  auto: 全程自动推进，仅在交付前暂停                                    │
│  review: 每步暂停，用户审阅确认后推进                                  │
└──┬──────┬──────────┬──────────┬──────────┬──────────┬──────────┬──────────┘
   │      │          │          │          │          │          │
  ┌▼────┐ ┌▼────────┐ ┌▼────────┐ ┌▼────────┐ ┌▼────────┐ ┌▼────────┐ ┌▼────────┐
  │00-P  │ │01-Req   │ │02-IIA   │ │03-DDD   │ │04-Data  │ │05-Design│ │06-Writer│
  │Parser│ │Refine   │ │Industry │ │Arch     │ │Model    │ │Synth    │ │Solution │
  └─────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘ └──────────┘
  文档解析  需求提炼    行业增强     DDD架构      数据模型     设计综合      概设输出
  (防截断)
```

## 二、7 阶段工作流

| # | Agent | 核心职责 | 推理焦点 |
|:---:|-------|---------|---------|
| 0 | **00-Document Parser** ⭐新 | 文档格式识别 → 表格+段落完整提取 → 截断检测 | 数据源完整了吗？ |
| 1 | **01-Requirement Refinement** | 需求文档 → 业务目标 → Actor → 流程 → 事件 → 能力 → 痛点 | 业务到底怎么运转？产生什么事件？ |
| 2 | **02-Industry Insight** ⭐V1.3 | 语义搜索知识库 → 行业模式匹配 → 异常边界 → 不合理之处 → 异常流程处理 → **⭐V1.4 输出5维成熟度** | 行业怎么做？缺了什么？成熟度多少？ |
| 3 | **03-DDD Architecture** ⭐V1.4 | 领域识别 → 边界划分 → 限界上下文 → **small-aggregates-first 聚合** → 服务划分 → 架构 | 边界在哪？聚合能拆多细？一致性如何保证？ |
| 4 | **04-Data Model** ⭐V1.4 | 实体归属 → ER 关系 → 指标 → DDL（含Context前缀） | 数据怎么建模？字段归谁？表名有归属吗？ |
| 5 | **05-Design Synthesis** | 设计意图 → 产品结构 → 体验策略 → 取舍 → Writer 表达策略 | 怎么表达才有设计感？ |
| 6 | **06-Solution Writer** ⭐V1.4 | AE 9 章概设输出 → **异常场景E1-E1n枚举** → 飞书交付 | 怎么写？异常覆盖全了吗？ |

---

## 三、两种模式

### 直通模式 (auto)

```
接收需求 → Agent 0（不暂停）→ 1→2→3→4→5→6 自动执行 → 9 章概设输出到飞书
         ↑                      ↑
    Preflight权限检查    仅在交付前暂停确认
    + 文档完整性检查
```

**适用场景**：需求明确（成熟度≥50）、快速出稿、格式性输出

### 审阅模式 (review)

```
接收需求 → Agent 0（不暂停，自动完整性检查）→
       → Agent 1 → 暂停 → 用户审阅/补充 → 继续
       → Agent 2 → 暂停 → 用户审阅/补充 → 继续
       → Agent 3 → 暂停 → 用户审阅/补充 → 继续
       → Agent 4 → 暂停 → 用户审阅/补充 → 继续
       → Agent 5 → 暂停 → 用户审阅/补充 → 继续
       → Agent 6 → 输出到飞书
```

**适用场景**：需求模糊（成熟度<50）、需要逐步确认、协作式设计

### ⛔ 成熟度门控规则 ⭐V1.2

| 条件 | auto 模式行为 | review 模式行为 |
|------|-------------|---------------|
| 成熟度 ≥70 | 正常自动推进 | 正常逐步确认 |
| 成熟度 50-69 | 自动推进，STAGE_5 展示风险提示 | 正常逐步确认 |
| 成熟度 <50 | **⛔ 暂停并警告**：建议切换为 review 模式。所有后续设计基于行业经验推断，大量"假设"标注 | ⚠️ 提示用户：以下设计以假设为主，第5/8章密集标注 |

---

## 四、设计原则

### Schema-first
每个 Agent 的输入/输出有明确定义的 Schema。见 `schemas/` 目录。

### 推理链强制
每个设计决策必须附 `reasoning`，解释"为什么"。

### 架构记忆
全流程共享已确认决策。每个后续 Agent 必须在推理时引用 `architecture_memory` 中的相关决策。见 `orchestrator/architecture_memory.md`。

### 7 模式共用同一 Agent 链
直通模式和审阅模式使用相同的 7 个 Agent，仅在 Orchestrator 层通过 `mode` 参数控制暂停策略。Agent 本身不感知模式。00-Document Parser 在任何模式下都不暂停。

### 数据源完整性优先 ⭐V1.2 新增
00-Document Parser 负责零截断提取，01 Agent 启动前强制校验 document_parse_report。发现数据截断 → 标记受影响字段为 `inferred` 置信度，不得将截断源数据标为 `exact`。

### 聚合拆分粒度 ⭐V1.4 新增 — small-aggregates-first

**原则**：优先细粒度聚合，事务边界清晰优于聚合数量少。

**4级拆分信号**（满足任一即拆分）：

| 信号 | 条件 | 示例 |
|------|------|------|
| S1-独立生命周期 | 实体可以脱离父实体独立创建/修改 | 考试安排可脱离考试需求独立操作 → 拆为独立聚合 |
| S2-不同一致性要求 | 不同实体的事务一致性要求不同 | 报名审核和报名申请有不同的最终一致性窗口 → 拆 |
| S3-高并发热点 | 多个流程并发操作同一数据 | 容量更新和报名创建并发冲突 → 拆 |
| S4-不同参与者 | 不同角色/团队负责不同操作 | 承包商报名 vs 专员审核 → 拆 |

**反模式**：为追求"聚合少"强行合并 → 导致一个聚合内有多个不变量组 → 事务边界模糊

**目标基准**：中等复杂度系统推荐 6-10 个聚合

### 策略描述业务化 ⭐V1.4 新增

**策略（Policy）必须描述业务规则，禁止使用UI/技术术语替代。**

```
✅ 正确（业务规则）：
  POL-001: "报名人数不得超过开班容量的剩余名额"
  POL-002: "培训需求必须在专员审核通过后方可进入考试流程"
  POL-003: "同一人在同一班级只能有一条有效报名记录"
  POL-004: "退回的报名允许申请人重新提交，重复提交次数无硬性限制但需记录退回历史"

❌ 错误（UI/技术行为）：
  POL-004: "路由到审核列表"
  POL-004: "更新附件存储路径"
  POL-004: "触发页面刷新"
```

**检查方法**：策略描述能否在不看系统的情况下被领域专家理解？能→业务规则。不能→技术行为。

### 异常场景枚举 ⭐V1.4 新增

**第3章必须包含异常场景清单**（E1 → E1n 格式），独立于正常流程。

覆盖维度：
- E-边界条件：满额报名、空列表、过期数据
- E-业务规则违反：重复报名、权限不足
- E-异常流程：退回后处理、超期未处理、系统异常
- E-数据异常：附件格式错误、必填缺失

**输出格式**：

```markdown
### 3.X 异常场景补充（需求文档未覆盖）

| # | 缺失场景 | 触发条件 | 建议处理 |
|---|---------|---------|---------|
| E1 | 满额报名 | 剩余容量=0时仍有报名提交 | 提示"名额已满"，不可提交 |
| E2 | 重复报名 | 同一人报名同一班级 | 唯一性校验，提示"您已报名" |
| ... | ... | ... | ... |
```

### 成熟度评估标准化 ⭐V1.4 新增

**02-Industry Insight Agent 必须输出5维成熟度明细**，不可只有总分。

```yaml
requirement_maturity:
  total: 58                     # 5维加权平均
  dimensions:
    business_completeness: 55   # 业务功能描述完整度（权重30%）
    data_certainty: 60          # 数据字段/关系明确度（权重25%）
    process_clarity: 50         # 流程/状态机清晰度（权重20%）
    role_clarity: 75            # 角色/权限明确度（权重15%）
    integration_certainty: 40   # 外部系统对接明确度（权重10%）
  evidence:
    - "需求文档45段落+11表格，功能描述充足但流程细节不足"
    - "考试安排'需考试培训过滤逻辑另行处理'降低 process_clarity"
    - "鲁软平台对接接口规范未提供降低 integration_certainty"
    - "角色划分明确(2角色)，但'开课发起人'权限边界模糊"
```

---

## 五、输出结构（AE 9 章）

| 章 | 内容 | 数据来源 |
|:---:|------|---------|
| 1 | 功能清单 | 01 + 02 + 05（设计主线） |
| 2 | 系统架构设计 | 03 + 05（产品结构） |
| 3 | 业务流程设计 ⭐含异常场景E1-E1n | 01 + 02 + 03 + 05（主工作台+异常） |
| 4 | 数据模型设计 ⭐表名含Context前缀 | 04 |
| 5 | 功能设计 | 01 + 03 + 05（Writer 表达策略） |
| 6 | 权限设计 | 03 |
| 7 | 非功能设计 | 02 + 03 |
| 8 | 遗留问题 | 01 + 02 + 03 + 05（tradeoffs） |
| 9 | 工作量评估 ⭐按服务/分项拆分 | 03（按 Context 拆分 → 配置/开发/测试分项） |

### 表命名前缀规范 ⭐V1.4

**所有DDL表名必须带有Context归属前缀**，格式：`{context_prefix}_{entity_name}`

| Context | 前缀 | 示例 |
|---------|:---:|------|
| TrainingPlanContext | `tp_` | `tp_training_plan`, `tp_training_plan_student` |
| EnrollmentContext | `enr_` | `enr_enrollment`, `enr_enrollment_student` |
| ApprovalContext | `appr_` | `appr_training_need`, `appr_training_need_student` |
| ExamContext | `exam_` | `exam_exam_need`, `exam_exam_arrangement`, `exam_exam_score` |
| SelfTrainingContext | `st_` | `st_self_training`, `st_self_training_student` |
| CourseContext | `crs_` | `crs_course_ledger`, `crs_course_teacher`, `crs_course_attachment` |

**优点**：
1. SQL中一眼识别表所属业务域
2. 避免不同Context同名表冲突
3. 迁移/归档可按前缀批量操作
4. 符合飞书多维表格的企业命名习惯

---

## 六、飞书交付 ⭐V1.2

### 飞书文档创建所需权限（完整清单）

在飞书开放平台 → 应用详情 → 权限管理 中必须开通以下权限：

| 权限 | 用途 | 必要 |
|------|------|:---:|
| `docx:document:create` | 创建文档 | ✅ 必须 |
| `docx:document:write_only` | 写入文档内容 | ✅ 必须 |
| `docx:document:readonly` | 读取文档内容 | ✅ 必须 |
| `offline_access` | 长期 token 刷新 | ✅ 必须 |
| `board:whiteboard:node:create` | 画板创建（批量权限校验） | ✅ 必须 |
| `wiki:node:create` | 知识库节点创建 | 建议 |
| `wiki:node:read` | 知识库节点读取 | 建议 |
| `docs:document.media:upload` | 文档媒体上传 | 建议 |

### Preflight Check（编排启动前自动执行）⭐V1.2

Orchestrator 在 STAGE_0 启动时执行：

```yaml
preflight_check:
  feishu_permissions:
    - check: "docx:document 核心权限是否已开通？"
      action_if_fail: "⛔ 提示用户开通权限，列出缺失权限清单，暂停编排"
  
  document_format:
    - check: "是否为 .docx 格式？"
      action_if_true: "启用 00-Document Parser 完整提取（段落+表格零截断）"
    - check: "是否为纯文本/Markdown？"
      action_if_true: "跳过 00 Agent，直接传入 01 Agent"
  
  requirement_maturity:
    - check: "STAGE_2 输出的 score < 50？"
      action_if_auto: "⛔ 暂停：所有功能设计仍需大量行业经验推断，强烈建议切换为 review 模式逐步确认"
      action_if_review: "⚠️ 提示：以下设计以假设为主，第5章/第8章将密集标注'假设'和'待确认'"
```

### 交付优先级

1. **飞书在线文档**（推荐）：`feishu_create_doc` + `feishu_update_doc append` 分批写入
2. **降级方案**：飞书 API 不可用时，通过飞书消息发送完整 Markdown 文件
3. **本地备份**：始终生成 `/tmp/<project_name>_overview_design.md` 备份

### 分批写入策略 ⭐V1.2

飞书文档写入时按章节分批（而非按固定行数），避免超时：

| 批次 | 内容 | 预估行数 |
|:---:|------|:---:|
| 1 | 封面 + 第1章 功能清单 + 5维成熟度明细 | ~60行 |
| 2 | 第2章 系统架构 | ~60行 |
| 3 | 第3章 业务流程（含异常场景E1-E1n） | ~90行 |
| 4 | 第4章 数据模型（DDL含Context前缀） | ~120行 |
| 5 | 第5章 功能设计 | ~100行 |
| 6 | 第6+7章 权限+非功能 | ~50行 |
| 7 | 第8+9章 遗留问题+工作量（按服务/分项拆分） | ~60行 |

### 交付权限降级策略 ⭐V1.3

类比 ae-design V6 的强制 `public_access: required` 策略，design-workflow 在交付时执行 5 级降级：

| Level | 条件 | 输出 | 状态 |
|:---:|------|------|:---:|
| 0 | 创建+写入+public_access 全成功 | 飞书链接 + public_access=true | ✅ |
| 1 | public_access 设置失败（重试1次后） | 飞书链接 + 手动权限指引 | ⚠️ |
| 2 | 部分批次写入失败 | 飞书链接(不完整) + 本地完整 MD | ⚠️ |
| 3 | 文档创建失败 | 飞书消息中的 MD 文件 | ❌ |
| 4 | 飞书 API 完全不可用 | 本地 MD + 手动导入指引 | ❌ |

**核心原则**：永远不丢数据 — 每个 Level 都保证本地 MD 备份。

---

## 七、Mermaid 图表与渲染 ⭐V1.3

### 图表使用时机

| 图表类型 | 生成者 | 渲染时机 | 用途 |
|------|:---:|:---:|------|
| 事件流图 (Event Flow) | 01 Agent | STAGE_1 → 直接写入 Ch3 | 展示 Command → Event → Policy 链路 |
| Context Map | 03 Agent | STAGE_3 → 直接写入 Ch3.4 | 展示限界上下文关系（OHS+PL/ACL/CF/CR 等） |
| 服务依赖图 | 03 Agent | STAGE_3 → 直接写入 Ch2.5 | 展示服务间通信关系 |
| ER 图 | 04 Agent | STAGE_4 → 直接写入 Ch4.2 | 展示实体关系（表名含Context前缀） |
| **序列图 ⭐V1.4 新增** | 03 Agent | STAGE_3 → 写入 Ch3.3 | 展示核心业务流程参与者交互 |

### 渲染工具

`scripts/render_mermaid.py` 用于将 Mermaid 代码块渲染为 PNG 图片：

```bash
# 用法
python3 scripts/render_mermaid.py --input <mermaid_code.mmd> --output <output.png>

# 或从 stdin 读取
cat diagram.mmd | python3 scripts/render_mermaid.py --output diagram.png
```

**渲染时机**：
- 仅在 06 Writer 准备好全部 Mermaid 代码块后批量调用
- 渲染失败不影响正文（Mermaid 代码块已内嵌）
- PNG 图片通过 `feishu_doc_media insert` 插入飞书文档对应位置

### Mermaid 代码块规范

```
✅ 正确：内嵌在正文中
  ```mermaid
  erDiagram
    enr_enrollment ||--o{ enr_enrollment_student : "1:N"
  ```

❌ 错误：不放外部链接
  ![ER图](https://mermaid.ink/img/...)

❌ 错误：不依赖外部渲染服务
  请在浏览器打开 xxx.mermaid.live...
```

---

## 八、资源文件

| 路径 | 说明 |
|------|------|
| `orchestrator/orchestrator.md` | 双模式编排器（V1.4：含交付降级 + 聚合粒度指引） |
| `orchestrator/architecture_memory.md` | 架构记忆模型 |
| `orchestrator/smart_state_machine.md` | 智能状态机（7 阶段 + 门控） |
| `agents/00-document-parser.md` | 文档解析 Agent（⭐V1.2） |
| `agents/01-requirement-refinement.md` | 需求提炼 Agent |
| `agents/02-industry-insight.md` | 行业经验增强 Agent（⭐V1.4：5维成熟度评估） |
| `agents/03-ddd-architecture.md` | DDD 架构设计 Agent（⭐V1.4：small-aggregates-first 指引） |
| `agents/04-data-model.md` | 数据模型设计 Agent（⭐V1.4：表命名前缀规范） |
| `agents/05-design-synthesis.md` | 设计综合 Agent |
| `agents/06-solution-writer.md` | 概设输出 Agent（⭐V1.4：异常场景E1-E1n + 策略业务化检查） |
| `schemas/` | Agent 输入输出 Schema（7 个） |
| `scripts/` | 飞书发布 + Mermaid 渲染 |
| `templates/` | 概设 9 章结构模板 |

---

## 九、与源 Skills 的复用关系

| 本 Skill Agent | 复用自 ddd-solution | 复用自 ae-design |
|:---:|:---:|:---:|
| 00-Document Parser | — | — ⭐独立新增 |
| 01-Req Refine | 01-BD（事件风暴） | Requirement Agent（结构化需求） |
| 02-IIA | 02-IIA（行业经验）⭐V1.4 5维成熟度 | — |
| 03-DDD Arch | 03-SDD + 04-TAA ⭐V1.4 small-aggregates | architecture_design（部分） |
| 04-Data Model | 05-DG（数据部分）⭐V1.4 Context前缀 | Domain Agent + Database Agent |
| 05-Design Synthesis | — | Design Synthesis Agent |
| 06-Writer | 06-SW（输出结构）⭐V1.4 异常枚举+策略检查 | Writer Agent（9 章结构） |

---

## 十、快速参考

```
直通模式：   "给我做xxx系统的概设" → Preflight → 全自动输出（成熟度≥50）
审阅模式：   "帮我逐步做xxx系统的概设" → 每步暂停确认（成熟度<50 推荐）
```

## 十一、变更日志

### V1.4 (2026-06-01) ⭐ 基于 OpenClaw V1.3 × Hermes V2.0 互评驱动
- ⭐ **聚合拆分粒度指引**：small-aggregates-first 原则 + 4级拆分信号（S1-S4），目标基准 6-10 聚合
- ⭐ **成熟度5维标准化评估**：business_completeness/data_certainty/process_clarity/role_clarity/integration_certainty + 权重 + evidence
- ⭐ **异常场景枚举**：第3章 E1-E1n 格式，覆盖边界条件/业务规则违反/异常流程/数据异常
- ⭐ **策略描述业务化**：禁止UI/技术行为替代业务规则 + 领域专家可理解性检查
- ⭐ **表命名前缀规范**：Context前缀（tp_/enr_/appr_/exam_/st_/crs_）+ 命名模板
- ⭐ **工作量按服务/分项拆分**：每服务拆配置/开发/测试分项 + 15%缓冲
- ⭐ **新增序列图**：第3种Mermaid类型（sequenceDiagram），展示核心流程参与者交互
- 02 Agent 新增5维成熟度输出 schema
- 03 Agent 新增聚合拆分决策日志
- 06 Writer 新增异常场景完整性检查 + 策略业务化校验

### V1.3 (2026-05-30)
- ⭐ 02 Industry Insight Agent 新增语义搜索（类比 ae-design Knowledge Agent）
- ⭐ 新增飞书交付权限降级策略：5 级降级（Level 0-4）
- ⭐ 新增 schemas/document-parse.schema.yaml
- ⭐ 新增 schemas/solution-writer.schema.yaml
- ⭐ SKILL.md 新增「七、Mermaid 图表与渲染」
- 修复 SKILL.md 宣称 6 Agent → 实际 7 Agent

### V1.2 (2026-05-29)
- ⭐ 新增 00-Document Parser Agent
- ⭐ 01 Agent 新增数据源完整性强制校验
- ⭐ 新增 Preflight Check
- ⭐ 新增成熟度门控规则
- ⭐ 新增分批写入策略

### V1.1 (2026-05-29)
- ⭐ 新增 05-Design Synthesis Agent

### V1.0 (2026-05-29)
- 初始版本：5 Agent 链
