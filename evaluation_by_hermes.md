# Hermes 对 OpenClaw 概设的评价

> 评价人：Hermes Agent (design-workflow V2.0)
> 被评价：OpenClaw (design-workflow V1.3)
> 评价日期：2026-06-01

---

## 一、总体对比

| 维度 | Hermes | OpenClaw | 优势 |
|------|:---:|:---:|------|
| 命令/事件 | 10/10 | 17/16 | OpenClaw 更细粒度 |
| 限界上下文 | 5 | 6 | 持平 |
| 聚合 | 8 | 6 | Hermes 更细 |
| DDL 表 | 15 | 17 | OpenClaw 更全 |
| 文档行数 | 373 | 723 | OpenClaw 更详尽 |
| Mermaid 图 | 2 | 4 | OpenClaw 完胜 |
| 成熟度评分 | 55/100(5维) | 58/100(无明细) | Hermes 透明 |
| 表标准字段 | 无 | 9标准字段 | OpenClaw 企业级 |
| 缓存策略 | 无 | Redis 分层 | OpenClaw 更完整 |
| 安全设计 | 基础 | AES256+幂等键 | OpenClaw 更细 |

---

## 二、OpenClaw 的亮点 ✅

### 2.1 事件风暴粒度
17个命令 + 16个事件，比我的10/10更细。特别是：
- `ReEnroll` + `EndEnrollment` 捕获了退回后重新提交/结束流程
- `TrainingNeedResubmitted` 独立事件区分首次提交和重新提交
- 附录A完整列出所有事件及下游影响，可追溯性强

### 2.2 Mermaid 图表
4张专业图表：系统结构图(graph TB)、时序图(sequenceDiagram)、ER图(erDiagram)、Context Map(graph LR)。比我的ASCII示意强太多。

### 2.3 企业级工程规范
- 每表9个标准字段（data_id, create_member, del_flag, source_system等）
- 审计留痕覆盖到操作人IP
- 身份证 AES256 加密 + 手机号脱敏
- 幂等键防重入

### 2.4 缓存策略
分层设计：课程(1h) → 会议室(24h) → 人员组件(30min)，写时主动失效

### 2.5 附录
附录A完整事件清单 + 附录B生成记录，文档可维护性好

---

## 三、可改进之处 ⚠️

### 3.1 【争议】审核作为独立限界上下文

OpenClaw 将"审核"作为独立的第六个 Context (approval-service)，我对此有不同看法：

- **DDD 原则**：限界上下文应围绕业务语言一致性划分。"审核报名""审核培训需求""审核考试需求"虽然都叫"审核"，但分别属于报名、培训、考试三个业务域的语言体系，强行合并违反"同一Context内术语含义一致"原则。
- **更好的做法**：审核作为**横切领域服务(DomainService)**，嵌入各自的 Context 中。我的设计将审核逻辑保留在 TrainingClassContext 和 ExamContext 内，保持了业务语言的纯净性。
- **风险**：独立审核服务增加了一次RPC调用，简单CRUD审核变成了分布式事务。

### 3.2 POL-004 偏技术化

`RouteTrainingNeedForReview` → "路由到审核列表" 描述的是UI/技术行为，不是业务规则。策略应描述业务约束，如"培训需求必须由培训部专员在24小时内处理"。

### 3.3 表命名缺少 Context 归属

`t_training_plan`、`t_enrollment`、`t_training_need` 分属不同 Context，但表名无前缀区分。建议：`tc_training_plan`(TrainingClassContext)、`enr_enrollment`(EnrollmentContext) 等。

### 3.4 成熟度评估无明细

概设先导段落提到"成熟度58"，但未给出评分维度和依据。我的 STAGE_2 输出了5维评分表。

---

## 四、我的自评弱点

| 弱点 | 说明 |
|------|------|
| 命令/事件过少 | 我合并了部分粒度（如退回重提交没有独立事件） |
| 缺 Mermaid | 只有文本示意图 |
| 缺缓存/安全细节 | 只在第7章简单提及 |
| 工作量拍脑袋 | 83人天缺乏分服务拆分 |
| 文档偏短 | 373行 vs 723行，信息密度低 |

---

## 五、综合评价

两者都完成了需求文档→AE 9章概设的完整流程，功能覆盖无遗漏。

- **OpenClaw 强在**：工程细节、图表、规范、完整性（更像交付物）
- **Hermes 强在**：DDD 划分的严谨性、Context 边界的 reasoning、成熟度评估透明

**互补建议**：OpenClaw 将审核服务改回各 Context 内的领域服务；Hermes 补充 Mermaid 图表和企业级表规范。

---

*评价依据：双方上传至 https://github.com/newtip/design 的概设文件*
