# STAGE_1: Requirement Refinement Agent — 执行结果

## business_model

### 项目信息
- project_name: 承包商培训管理系统
- business_goal: 建立统一的承包商培训管理平台，实现培训计划制定→培训报名→报名审核→培训执行→考试评估的全流程闭环管理
- requirement_maturity_quick:
  - completeness: medium
  - clarity: medium
  - consistency: medium
  - open_issues_flagged: true

## Channel A：事件风暴

### Commands

| cmd_id | command_name | actor | description | triggers_event |
|--------|-------------|-------|-------------|----------------|
| CMD-001 | CreateTrainingPlan | 培训部专员/承包商接口人 | 创建开班计划 | EVT-001 |
| CMD-002 | EnrollTraining | 承包商接口人 | 培训报名 | EVT-002 |
| CMD-003 | ApproveEnrollment | 培训部专员 | 审核报名 | EVT-003 |
| CMD-004 | RejectEnrollment | 培训部专员 | 退回报名 | EVT-004 |
| CMD-005 | ReSubmitEnrollment | 承包商接口人 | 重新发起报名 | EVT-005 |
| CMD-006 | SubmitTrainingDemand | 承包商接口人 | 提交培训需求 | EVT-006 |
| CMD-007 | ApproveDemand | 培训部专员 | 同意培训需求 | EVT-007 |
| CMD-008 | RejectDemand | 培训部专员 | 退回培训需求 | EVT-008 |
| CMD-009 | InitiateExamDemand | 承包商接口人 | 发起考试需求 | EVT-009 |
| CMD-010 | ProcessExamDemand | 培训部专员 | 处理考试需求 | EVT-010 |
| CMD-011 | ArrangeExam | 培训部专员 | 安排考试 | EVT-011 |
| CMD-012 | ImportExamScore | 培训部专员 | 录入考试成绩 | EVT-012 |
| CMD-013 | CloseEnrollment | 承包商接口人 | 结束报名流程 | EVT-013 |
| CMD-014 | RecordOnJobTraining | 承包商接口人 | 录入在岗培训信息 | EVT-014 |

### Events

| event_id | event_name | source_command | description |
|----------|-----------|---------------|-------------|
| EVT-001 | TrainingPlanCreated | CMD-001 | 开班计划已创建 |
| EVT-002 | TrainingEnrollmentSubmitted | CMD-002 | 培训报名已提交 |
| EVT-003 | EnrollmentApproved | CMD-003 | 报名已通过 |
| EVT-004 | EnrollmentRejected | CMD-004 | 报名已退回 |
| EVT-005 | EnrollmentReSubmitted | CMD-005 | 报名已重新提交 |
| EVT-006 | TrainingDemandSubmitted | CMD-006 | 培训需求已提交 |
| EVT-007 | TrainingDemandApproved | CMD-007 | 培训需求已通过 |
| EVT-008 | TrainingDemandRejected | CMD-008 | 培训需求已退回 |
| EVT-009 | ExamDemandInitiated | CMD-009 | 考试需求已发起 |
| EVT-010 | ExamDemandProcessed | CMD-010 | 考试需求已处理 |
| EVT-011 | ExamArranged | CMD-011 | 考试已安排 |
| EVT-012 | ExamScoreImported | CMD-012 | 考试成绩已录入 |
| EVT-013 | EnrollmentClosed | CMD-013 | 报名流程已结束 |
| EVT-014 | OnJobTrainingRecorded | CMD-014 | 在岗培训信息已录入 |

### Policies

| policy_id | policy_name | triggered_by | type | description |
|-----------|------------|-------------|------|-------------|
| POL-001 | ValidateCapacity | EVT-002 | synchronous | 校验开班容量是否充足（剩余容量=容量-已报名人数） |
| POL-002 | NotifyApprover | EVT-002 | asynchronous | 通知培训部专员有待审核报名 |
| POL-003 | UpdateCapacity | EVT-003 | synchronous | 报名通过后更新已占用容量 |
| POL-004 | NotifyApplicantReject | EVT-004 | asynchronous | 通知申请人报名被退回 |
| POL-005 | FilterContractorData | EVT-001 | synchronous | 承包商接口人仅可见本人提交数据 |

### Event Flows

| flow_id | flow_name | type | steps |
|---------|-----------|------|-------|
| FLOW-001 | 开班报名审批链路 | primary | CMD-001→EVT-001→CMD-002→EVT-002→POL-001→POL-002→CMD-003→EVT-003 |
| FLOW-002 | 报名退回重提链路 | primary | CMD-004→EVT-004→POL-004→CMD-005→EVT-005 |
| FLOW-003 | 培训需求审批链路 | primary | CMD-006→EVT-006→CMD-007→EVT-007 |
| FLOW-004 | 考试需求处理链路 | primary | CMD-009→EVT-009→CMD-010→EVT-010→CMD-011→EVT-011 |

### Capability Map

| cap_id | name | type | commands |
|--------|------|------|----------|
| CAP-001 | 培训计划管理 | core | CMD-001 |
| CAP-002 | 培训报名管理 | core | CMD-002,CMD-003,CMD-004,CMD-005,CMD-013 |
| CAP-003 | 培训需求管理 | supporting | CMD-006,CMD-007,CMD-008 |
| CAP-004 | 考试管理 | core | CMD-009,CMD-010,CMD-011,CMD-012 |
| CAP-005 | 在岗培训管理 | supporting | CMD-014 |

### Actors

| actor_id | name | type | data_scope | menu_permissions |
|----------|------|------|------------|-----------------|
| ACT-001 | 培训部专员 | business | 全部数据 | 开班计划,培训报名,报名审核,培训需求,考试需求,考试安排,成绩录入 |
| ACT-002 | 承包商接口人 | business | 本人/本单位数据 | 开班计划,培训报名,培训需求,考试需求发起,在岗培训信息 |

## Channel B：结构化需求提取

### Functions

| id | name | priority | actors | description |
|----|------|----------|--------|-------------|
| FUNC-001 | 开班计划-新增(培训专员) | P0 | ACT-001 | 培训专员创建开班计划，选择培训月份→课程→自动带出编码/教员/教室 |
| FUNC-002 | 开班计划-新增(承包商) | P1 | ACT-002 | 承包商接口人创建面向本单位培训班，默认"是"承包商开班 |
| FUNC-003 | 开班计划-列表/编辑/删除 | P0 | ACT-001,ACT-002 | 按角色过滤数据，承包商仅见本人提交 |
| FUNC-004 | 培训报名-列表 | P0 | ACT-002 | 展示所有对外开放的承包开班计划 |
| FUNC-005 | 培训报名-报名 | P0 | ACT-002 | 填写报名人数+人员子表(姓名/公司/工号/手机号)，自动带出 |
| FUNC-006 | 培训报名-我已报名 | P1 | ACT-002 | 查看本人报名记录及审核状态 |
| FUNC-007 | 报名审核-列表 | P0 | ACT-001 | 展示所有待处理报名申请 |
| FUNC-008 | 报名审核-处理 | P0 | ACT-001 | 同意/退回操作，同意完成闭环，退回可重新申请 |
| FUNC-009 | 培训需求-新增 | P1 | ACT-002 | 提交培训需求(课程/人数/期望时间/人员子表) |
| FUNC-010 | 培训需求-审核 | P1 | ACT-001 | 查看并同意/退回培训需求 |
| FUNC-011 | 在岗培训信息 | P2 | ACT-001,ACT-002 | 录入/查看承包商自主培训信息及成绩 |
| FUNC-012 | 考试需求-发起 | P0 | ACT-002 | 从已完成培训中筛选需考试项目，发起考试申请 |
| FUNC-013 | 考试需求-处理 | P0 | ACT-001 | 审核考试需求申请 |
| FUNC-014 | 考试安排 | P0 | ACT-001 | 对已审核需求安排考试 |
| FUNC-015 | 培训成绩录入 | P1 | ACT-001 | 录入考试成绩 |

### Entities

| id | name | description | parent_entity |
|----|------|-------------|---------------|
| ENT-001 | 开班计划 | 培训班级信息 | null |
| ENT-002 | 学员信息(子表) | 开班计划中的学员列表 | ENT-001 |
| ENT-003 | 培训报名 | 报名申请记录 | null |
| ENT-004 | 报名人员(子表) | 报名中的人员列表 | ENT-003 |
| ENT-005 | 培训需求 | 培训需求申请 | null |
| ENT-006 | 培训需求人员(子表) | 需求中的人员列表 | ENT-005 |
| ENT-007 | 考试需求 | 考试申请记录 | null |
| ENT-008 | 考试安排 | 考试安排记录 | null |
| ENT-009 | 培训成绩 | 考试成绩记录 | null |
| ENT-010 | 在岗培训信息 | 承包商自主培训记录 | null |

### Fields（核心字段，按实体分组）

**ENT-001 开班计划：**
| id | field_name | field_location | type_hint | required | auto_fill |
|----|-----------|---------------|-----------|----------|-----------|
| FLD-001 | 班级名称 | form_field,list_column | 单行文本 | true | false |
| FLD-002 | 是否承包商开班 | form_field | 布尔 | true | true(默认否) |
| FLD-003 | 开班单位 | form_field,list_column | 文本 | true | false |
| FLD-004 | 培训月份 | form_field | 下拉 | true | false |
| FLD-005 | 培训课程 | form_field,list_column | 下拉 | true | 关联培训计划 |
| FLD-006 | 课程编码 | form_field | 文本 | true | true(选择课程) |
| FLD-007 | 培训教室 | form_field,list_column | 下拉 | true | true(选择课程) |
| FLD-008 | 教员 | form_field,list_column | 用户选择 | true | true(选择课程/教员台账) |
| FLD-009 | 开始时间 | form_field,list_column | 日期时间 | true | false |
| FLD-010 | 结束时间 | form_field,list_column | 日期时间 | true | false |
| FLD-011 | 培训容量 | form_field,list_column | 数字 | true | false |
| FLD-012 | 培训简介 | form_field,detail_field | 多行文本 | false | false |

**ENT-002 学员信息子表：**
| FLD-013 | 学员姓名 | subtable_field | 人员组件 | true | false |
| FLD-014 | 所在公司 | subtable_field | 文本 | true | true(选姓名) |
| FLD-015 | 工号 | subtable_field | 文本 | true | true(选姓名) |
| FLD-016 | 手机号 | subtable_field | 文本 | true | true(选姓名) |

**ENT-003 培训报名：**
| FLD-017 | 本次报名人数 | form_field | 数字 | true | false |
| FLD-018 | 剩余容量 | form_field,list_column | 数字 | false | true(计算) |
| FLD-019 | 审核状态 | list_column | 枚举(待审核/已通过/待重新申请) | false | true(系统) |

### Workflows

| id | name | type | steps | branches |
|----|------|------|-------|----------|
| WF-001 | 开班报名审批流程 | approval | 创建开班→发起报名→审核→通过/退回 | 退回→重新发起→再次审核; 点击结束→流程终止 |
| WF-002 | 培训需求审批流程 | approval | 提交需求→审核→通过/退回 | 退回→重新提交→再次审核 |
| WF-003 | 考试需求处理流程 | approval | 发起考试需求→审核→安排考试 | |

### Business Rules

| id | rule | type | implementability |
|----|------|------|-----------------|
| RULE-001 | 承包商接口人仅可见本人提交的开班计划 | permission | frontend_filter |
| RULE-002 | 培训部专员可见系统中所有开班计划 | permission | frontend_filter |
| RULE-003 | 剩余容量=开班容量-本次报名人数-历史已报名人数 | data | submit_validation |
| RULE-004 | 审核状态：待审核→审核通过→已通过；审核退回→待重新申请 | flow | state_machine |
| RULE-005 | 选择培训月份过滤培训课程 | data | frontend_filter |
| RULE-006 | 选择课程后自动带出教室/编码/教员 | data | frontend_filter |
| RULE-007 | 学员姓名选择后自动带出公司/工号/手机号 | data | frontend_filter |
| RULE-008 | 列表按开始时间降序排序 | display | frontend_filter |
| RULE-009 | 承包商接口人只能看到自己新增的培训需求 | permission | frontend_filter |

### Open Questions

| q_id | question | category | potential_impact |
|------|----------|----------|-----------------|
| Q-001 | 剩余容量是否减去审核通过人数还是所有报名人数 | ambiguous | high |
| Q-002 | 培训月份选择后关联的"月度培训计划"数据来源（是否已有此模块） | missing_info | high |
| Q-003 | 考试安排中的"已审核需求"列表是否需要按承包商/课程筛选 | missing_info | medium |
| Q-004 | 培训成绩录入后是否需要通知承包商接口人 | missing_info | low |
| Q-005 | 在岗培训信息是从外部系统抓取还是手动录入 | missing_info | medium |
| Q-006 | 报名审核中的"组织部门/班主任"字段来源（开班计划中未出现） | ambiguous | medium |
| Q-007 | 培训程序录入功能的需求详细描述缺失 | missing_info | high |

### Source Anchor Index（核心锚点）

| anchor_id | entry_type | entry_id | source_location |
|-----------|-----------|----------|-----------------|
| SRC-001 | function | FUNC-001 | 1.2.2.1.1 开班计划 |
| SRC-002 | function | FUNC-004 | 1.2.2.1.2 培训报名 |
| SRC-003 | function | FUNC-007 | 1.2.2.1.3 报名审核 |
| SRC-004 | function | FUNC-009 | 1.2.2.1.4 培训需求 |
| SRC-005 | function | FUNC-011 | 1.2.2.1.5 在岗培训信息 |
| SRC-006 | function | FUNC-012 | 1.2.2.2.1 考试需求 |
| SRC-007 | rule | RULE-001 | 1.2.2.1.1 开班计划-数据描述 |
| SRC-008 | rule | RULE-004 | 1.2.2.1.2 培训报名-审核状态 |
| SRC-009 | actor | ACT-001 | 1.1.1.1 角色权限 |
| SRC-010 | actor | ACT-002 | 1.1.1.1 角色权限 |

### Bidirectional Binding Matrix

| function_id | related_events |
|-------------|---------------|
| FUNC-001 | EVT-001 |
| FUNC-004 | EVT-002 |
| FUNC-008 | EVT-003,EVT-004 |
| FUNC-005 | EVT-005,EVT-013 |
| FUNC-009 | EVT-006 |
| FUNC-010 | EVT-007,EVT-008 |
| FUNC-012 | EVT-009 |
| FUNC-013 | EVT-010 |
| FUNC-014 | EVT-011 |
| FUNC-015 | EVT-012 |

### Coverage

- all_functions_extracted: true
- all_events_identified: true
- all_workflows_captured: true
- all_business_rules_extracted: true
- all_fields_extracted: true
- source_anchor_coverage_pct: 85
- bidirectional_binding_complete: true
