# STAGE_5: Design Synthesis Agent — 执行结果

## design_synthesis

### 设计意图 (Design Intent)

- **summary**: 系统围绕"培训班级"这一核心业务对象运转。培训部专员制定开班计划→承包商接口人报名→专员审核→培训完成后发起考试→安排考试→录入成绩，形成培训全生命周期闭环。主工作台为培训部专员的"待办中心"（集中处理报名审核+需求审核+考试需求处理），承包商接口人的"我的培训"（跟踪报名状态+发起需求）。

- **primary_business_object**: TrainingPlan (开班计划)
- **primary_user_roles**: ACT-001(培训部专员), ACT-002(承包商接口人)
- **primary_workspace**: 待办中心(培训部专员) / 我的培训(承包商接口人)
- **core_event_chain**: 创建开班→报名→审核→通过→考试需求→安排→成绩录入
- **value_proposition**: "让承包商培训从计划到考试全程线上化，人多不乱的培训管理平台"

### 产品结构策略

| module_or_page | mapped_from | treatment | primary_actors | reason |
|---------------|-------------|-----------|---------------|--------|
| 待办中心 | CTX-002,CTX-003,CTX-005 | primary_workspace | ACT-001 | 所有审核任务的人口 |
| 开班计划管理 | CTX-001 | object_detail | ACT-001,ACT-002 | 核心对象CRUD |
| 培训报名 | CTX-002 | object_detail | ACT-002 | 报名操作页 |
| 报名审核 | CTX-002 | operation_center | ACT-001 | 审批处理 |
| 培训需求管理 | CTX-003 | supporting_module | ACT-001,ACT-002 | 需求提报 |
| 考试需求管理 | CTX-005 | operation_center | ACT-001,ACT-002 | 考试流程 |
| 考试安排 | CTX-005 | operation_center | ACT-001 | 安排操作 |
| 成绩录入 | CTX-006 | supporting_module | ACT-001 | 成绩管理 |
| 在岗培训信息 | CTX-004 | supporting_module | ACT-001,ACT-002 | 数据查看 |

### 体验策略

- **first_screen_focus**: 待办中心(培训部专员)→待审核报名列表; 我的培训(承包商)→报名状态跟踪
- **embedded_invocations**:
  - 开班计划详情页→内嵌"报名审核"入口(弹窗)
  - 报名详情页→内嵌"发起考试需求"入口(弹窗)
  - 考试需求处理→内嵌"安排考试"入口(抽屉)
- **overload_prevention**: 开班计划列表避免展示全部字段，行内按钮(详情/编辑/删除)+详情弹窗展示完整信息

### 设计取舍

| decision | reason | evidence |
|----------|--------|----------|
| 容量校验采用乐观锁而非悲观锁 | 并发量中等(<200在线)，乐观锁实现简单且性能更好 | PAT-004, RULE-003 |
| 智能填充字段存储为快照 | 保证历史开班计划的教员/教室信息不随后续变更而改变 | DEC-002, FLD-007 |
| 承包商开班计划面向所有承包商开放 vs 仅限发起单位 | 需求明确"对外开放"，最大化培训资源利用 | FUNC-004 |
| 报名审核通过后自动释放未用容量 | 需求未明确，暂取"审核通过占用，退回释放" | DEC-001 |

### 行业经验处理决策

| recommendation | source | status | design_handling |
|---------------|--------|--------|-----------------|
| 退回时释放容量 | REC-001 | recommended_not_confirmed | 第5章标注"建议"，第8章待确认 |
| 开班与考试关联 | REC-002 | recommended_not_confirmed | 第3章流程图体现关联 |
| 审批超时提醒 | REC-003 | assumption_for_review | 第7章非功能设计，第8章待确认 |
| 容量乐观锁 | REC-004 | recommended_not_confirmed | 第5章详细设计说明 |
| 操作审计留痕 | REC-005 | confirmed_by_requirement | 第7章安全设计(已确认) |
| 快照存储 | REC-006 | assumption_for_review | 第4章DDL注释标注快照 |
| 一级单位隔离 | REC-007 | recommended_not_confirmed | 第6章权限设计，第8章待确认 |
