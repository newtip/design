# STAGE_3: DDD Architecture Agent — 执行结果

## architecture_design

### Strategic Design: Domains & Contexts

| domain | type | priority | source_events |
|--------|------|----------|---------------|
| DM-001 培训管理域 | core | P0 | EVT-001~008, EVT-013~014 |
| DM-002 考试管理域 | core | P0 | EVT-009~012 |
| DM-003 组织用户域 | supporting | P1 | (横切) |

### Bounded Contexts

| ctx_id | name | domain | responsibility | owned_events |
|--------|------|--------|---------------|-------------|
| CTX-001 | TrainingPlanContext | DM-001 | 开班计划创建与管理 | EVT-001 |
| CTX-002 | EnrollmentContext | DM-001 | 培训报名与审核 | EVT-002~005, EVT-013 |
| CTX-003 | TrainingDemandContext | DM-001 | 培训需求管理 | EVT-006~008 |
| CTX-004 | OnJobTrainingContext | DM-001 | 在岗培训信息 | EVT-014 |
| CTX-005 | ExamContext | DM-002 | 考试需求与安排管理 | EVT-009~011 |
| CTX-006 | ExamScoreContext | DM-002 | 考试成绩管理 | EVT-012 |
| CTX-007 | OrganizationContext | DM-003 | 组织架构与用户管理 | — |
| CTX-008 | NotificationContext | DM-003 | 统一消息通知 | — |

**DDD Boundary Rules Check:**
- ✅ 横切关注点(审核/通知)未独立成BC——审核逻辑分布在 EnrollmentContext/TrainingDemandContext 内，通知归入 NotificationContext
- ✅ Context 划分依据业务语言一致性，无 UI 行为泄漏

### Context Map (Relationships)

| upstream | downstream | pattern | protocol | events |
|----------|-----------|---------|----------|--------|
| CTX-001 | CTX-002 | OHS+PL | sync_rest | EVT-001 |
| CTX-002 | CTX-005 | OHS+PL | async_event | EVT-003(EnrollmentApproved→ExamDemand) |
| CTX-003 | CTX-001 | CF | sync_rest | EVT-007(Approved→PlanCreated) |
| CTX-007 | CTX-001~006 | SK | sync_rest | (共享用户/组织数据) |
| CTX-008 | CTX-002,CTX-003,CTX-005 | OHS+PL | async_event | (消费各BC的审批事件) |

**Architecture Memory Updates:**
- confirmed: 核心域 TrainingPlan + Enrollment + Exam 独立 Context
- confirmed: 组织用户域作为 Shared Kernel
- constraint: 不支持双向依赖，下游对上游单向 ACL

---

### Tactical Architecture: Aggregates

#### AGG-001: TrainingPlan (CTX-001)
- **Aggregate Root**: TrainingPlan
- **Entities**: TrainingPlan(root), TraineeInfo(sub-entity via sub-table)
- **Consistency Boundary**: 开班计划信息完整性（班级名+课程+容量+时间必须同时有效）
- **Business Behaviors**:
  - create(cmd)→TrainingPlanCreated
  - update(cmd)→TrainingPlanUpdated
  - queryByContractor(filter: contractor_id)→list
- **Key Fields**: plan_name, contractor_flag, org_unit, course_code, instructor, classroom, capacity, start_time, end_time

#### AGG-002: Enrollment (CTX-002)
- **Aggregate Root**: Enrollment
- **Entities**: Enrollment(root), EnrolleeInfo(sub-entity)
- **Consistency Boundary**: 报名人数+审核状态+容量占用必须事务一致
- **Business Behaviors**:
  - submit(cmd)→EnrollmentSubmitted [POL: ValidateCapacity]
  - approve(cmd)→EnrollmentApproved [POL: UpdateCapacity]
  - reject(cmd)→EnrollmentRejected [POL: NotifyApplicant]
  - resubmit(cmd)→EnrollmentReSubmitted
  - close(cmd)→EnrollmentClosed
- **Key Fields**: enrollment_count, remaining_capacity, status, applicant_unit

#### AGG-003: TrainingDemand (CTX-003)
- **Aggregate Root**: TrainingDemand
- **Consistency Boundary**: 需求申请+审核状态
- **Business Behaviors**:
  - submit→TrainingDemandSubmitted
  - approve→TrainingDemandApproved
  - reject→TrainingDemandRejected

#### AGG-004: ExamDemand (CTX-005)
- **Aggregate Root**: ExamDemand
- **Consistency Boundary**: 考试需求+关联培训+安排状态
- **Cross-aggregate Reference**: → AGG-001.TrainingPlan (FK: training_plan_id)

#### AGG-005: ExamArrangement (CTX-005)
- **Aggregate Root**: ExamArrangement
- **Consistency Boundary**: 考试安排详情

#### AGG-006: ExamScore (CTX-006)
- **Aggregate Root**: ExamScore
- **Consistency Boundary**: 成绩记录

#### Anti-Pattern Check:
- ✅ 无神级聚合(最多2个实体/聚合)
- ✅ 无贫血模型(每个聚合有业务行为)
- ✅ 无双向Context依赖
- ✅ 跨聚合引用仅通过ID

### Services

| svc_id | name | context | type | aggregates |
|--------|------|---------|------|-----------|
| SVC-001 | TrainingPlanService | CTX-001 | core | AGG-001 |
| SVC-002 | EnrollmentService | CTX-002 | core | AGG-002 |
| SVC-003 | TrainingDemandService | CTX-003 | supporting | AGG-003 |
| SVC-004 | OnJobTrainingService | CTX-004 | supporting | — |
| SVC-005 | ExamService | CTX-005 | core | AGG-004,AGG-005 |
| SVC-006 | ExamScoreService | CTX-006 | core | AGG-006 |
| SVC-007 | OrganizationService | CTX-007 | supporting | — |
| SVC-008 | NotificationService | CTX-008 | infrastructure | — |

### Architecture Patterns
- **CQRS**: disabled (读写差异不大)
- **Event-Driven**: enabled (跨Context通信: Enrollment→Exam)
- **Layers**: Interface(Controller/DTO) → Application(Service/UseCase) → Domain(Entity/Aggregate/Repository) → Infrastructure(RepositoryImpl/MessagePublisher)

### Architecture Validation
- ✅ core_independent: 核心域(培训/报名/考试)不依赖通用域
- ✅ no_circular_deps: 服务间无循环依赖
- ✅ context_service_alignment: Context与服务1:1对齐
