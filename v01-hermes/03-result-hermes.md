# Agent 03 — DDD Architecture Result (Hermes)

## 苍南二期人事系统 — DDD Architecture Design

```yaml
architecture_design:
  project_name: "苍南二期人事系统"

  # ═══ Phase 1：战略设计 ═══
  domains:
  - domain_id: "DM-001"; domain_name: "试用期考核域"; domain_type: "core"; strategic_priority: "P0"; source_events: ["EVT-001","EVT-002","EVT-003","EVT-004","EVT-005","EVT-006","EVT-007","EVT-008","EVT-009"]; source_capabilities: ["CAP-001"]; reasoning: "核心人事流程，试用期员工考核与转正决策的直接承载"
  - domain_id: "DM-002"; domain_name: "技术岗位聘任域"; domain_type: "core"; strategic_priority: "P0"; source_events: ["EVT-010","EVT-011","EVT-012","EVT-013","EVT-014","EVT-015","EVT-016","EVT-017","EVT-018"]; source_capabilities: ["CAP-002","CAP-003"]; reasoning: "公司人才晋升核心机制，5种晋升类型+评审会+高级岗位，差异化程度最高"
  - domain_id: "DM-003"; domain_name: "职称管理域"; domain_type: "core"; strategic_priority: "P0"; source_events: ["EVT-022","EVT-023","EVT-024","EVT-025","EVT-026"]; source_capabilities: ["CAP-004"]; reasoning: "职称初定+评审+公示发文，涉及多轮审批和材料管理"
  - domain_id: "DM-004"; domain_name: "干部导师管理域"; domain_type: "supporting"; strategic_priority: "P1"; source_events: ["EVT-019","EVT-020","EVT-021"]; source_capabilities: ["CAP-005"]; reasoning: "支撑人才发展，导师结对+书库维护，非核心差异化"
  - domain_id: "DM-005"; domain_name: "人事档案管理域"; domain_type: "supporting"; strategic_priority: "P1"; source_events: ["EVT-027","EVT-028"]; source_capabilities: ["CAP-006"]; reasoning: "档案转入归档线上化，相对标准的流程"
  - domain_id: "DM-006"; domain_name: "信息安全管理域"; domain_type: "supporting"; strategic_priority: "P1"; source_events: ["EVT-029","EVT-030"]; source_capabilities: ["CAP-007"]; reasoning: "按敏感等级分级审批，业务价值高但非核心差异化"
  - domain_id: "DM-007"; domain_name: "人事大屏域"; domain_type: "supporting"; strategic_priority: "P2"; source_events: ["EVT-032"]; source_capabilities: ["CAP-008"]; reasoning: "数据可视化看板，支撑管理决策"
  - domain_id: "DM-008"; domain_name: "通知域"; domain_type: "generic"; strategic_priority: "P2"; source_events: ["EVT-031"]; source_capabilities: ["CAP-009"]; reasoning: "通用通知能力（钉钉/邮件），可复用"

  contexts:
  - context_id: "CTX-001"; context_name: "ProbationContext"; domain: "DM-001"; responsibility: "试用期考核任务书签订+试用期考核全流程"; owned_events: ["EVT-001","EVT-002","EVT-003","EVT-004","EVT-005","EVT-006","EVT-007","EVT-008","EVT-009"]; consumed_events: []; core_invariants: ["占比之和必须等于100%","考核任务书签订后才能发起考核","状态变换遵循状态机"]
  - context_id: "CTX-002"; context_name: "AppointmentContext"; domain: "DM-002"; responsibility: "技术岗位集中聘任(5种类型)+高级岗位任务书+高级岗位考核"; owned_events: ["EVT-010","EVT-011","EVT-012","EVT-013","EVT-014","EVT-015","EVT-016","EVT-017","EVT-018"]; consumed_events: []; core_invariants: ["晋升类型决定审批链长度","高级任务书通过后自动生成考核","评审会可跳过(培训工程师勾选)"]
  - context_id: "CTX-003"; context_name: "TitleContext"; domain: "DM-003"; responsibility: "职称初定+职称评审全流程(含公示发文)"; owned_events: ["EVT-022","EVT-023","EVT-024","EVT-025","EVT-026"]; consumed_events: []; core_invariants: ["职称初定仅限上一年校园招聘入职员工","职称评审支持公示发文"]
  - context_id: "CTX-004"; context_name: "MentorContext"; domain: "DM-004"; responsibility: "干部导师库管理+导师书库维护"; owned_events: ["EVT-019","EVT-020","EVT-021"]; consumed_events: []; core_invariants: ["每名导师最多带3名徒弟","赠书后自动更新书库库存"]
  - context_id: "CTX-005"; context_name: "ArchiveContext"; domain: "DM-005"; responsibility: "人事档案转入归档申请"; owned_events: ["EVT-027","EVT-028"]; consumed_events: []; core_invariants: ["支持本人发起+代发起+组织新增三种类型"]
  - context_id: "CTX-006"; context_name: "SecurityContext"; domain: "DM-006"; responsibility: "人力资源信息使用申请(按敏感等级分级审批+自动授权)"; owned_events: ["EVT-029","EVT-030"]; consumed_events: []; core_invariants: ["高敏感4级审批/低敏感2级审批","默认有效期7个工作日","操作日志记录"]
  - context_id: "CTX-007"; context_name: "DashboardContext"; domain: "DM-007"; responsibility: "人事大屏(干部/入职/离职数据可视化)"; owned_events: ["EVT-032"]; consumed_events: ["EVT-009","EVT-013","EVT-024","EVT-026"]; core_invariants: ["数据来源于SAP/HR系统定时同步","支持手动维护+自动统计"]
  - context_id: "CTX-008"; context_name: "NotificationContext"; domain: "DM-008"; responsibility: "统一通知(钉钉/邮件)"; owned_events: ["EVT-031"]; consumed_events: ["EVT-004","EVT-005","EVT-009","EVT-013","EVT-016","EVT-022","EVT-024","EVT-026","EVT-028","EVT-030"]; core_invariants: ["多渠道统一发送(钉钉+邮件)","模板化消息内容"]

  context_relationships:
  - upstream: "CTX-001"; downstream: "CTX-008"; pattern: "OHS+PL"; contract: {protocol:"async_event",events:["EVT-004","EVT-005","EVT-009"]}; reasoning: "考核状态变更→通知相关人员"
  - upstream: "CTX-002"; downstream: "CTX-008"; pattern: "OHS+PL"; contract: {protocol:"async_event",events:["EVT-013","EVT-016"]}; reasoning: "聘任/任务书审批结果→通知相关人员"
  - upstream: "CTX-003"; downstream: "CTX-008"; pattern: "OHS+PL"; contract: {protocol:"async_event",events:["EVT-022","EVT-024","EVT-026"]}; reasoning: "职称流程节点→通知相关人员"
  - upstream: "CTX-001"; downstream: "CTX-007"; pattern: "OHS+PL"; contract: {protocol:"async_event",events:["EVT-009"]}; reasoning: "考核归档→大屏数据更新"
  - upstream: "CTX-002"; downstream: "CTX-007"; pattern: "OHS+PL"; contract: {protocol:"async_event",events:["EVT-013"]}; reasoning: "聘任完成→大屏数据更新"

  ubiquitous_language:
  - term: "任务书"; english: "TaskBook"; context: "CTX-001"; definition: "师傅与徒弟签订的试用期考核任务书，含基础素质+专业素质指标及占比"
  - term: "聘任"; english: "Appointment"; context: "CTX-002"; definition: "技术岗位集中聘任流程，含5种晋升类型"
  - term: "评审会"; english: "ReviewMeeting"; context: "CTX-002"; definition: "培训工程师组织的技术岗位评审会议"
  - term: "述职述廉"; english: "DutyAndIntegrityReport"; context: "CTX-002"; definition: "高级技术岗位员工填写的述职述廉报告(7个模块)"
  - term: "职称初定"; english: "TitleDetermination"; context: "CTX-003"; definition: "新入职员工满足条件后自动触发的职称初次认定流程"
  - term: "职称评审"; english: "TitleReview"; context: "CTX-003"; definition: "正式员工申报的职称评审流程(含答辩/公示/发文)"
  - term: "导师库"; english: "MentorPool"; context: "CTX-004"; definition: "中高级干部作为导师的信息库(含徒弟结对+赠书记录)"
  - term: "信息使用申请"; english: "InfoAccessRequest"; context: "CTX-006"; definition: "按敏感等级分级的HR信息使用申请(自动授权+有效期)"
  - term: "数据敏感等级"; english: "DataSensitivityLevel"; context: "CTX-006"; definition: "高敏感(身份证/薪资等)和低敏感(工号/部门等)"

  boundary_validation:
    no_bidirectional_deps: true; reasoning: "所有Context关系均为单向(OHS+PL)，无循环依赖"
    core_independence: true; reasoning: "核心域(CTX-001/002/003)独立，不依赖其他核心域"
    data_ownership_clear: true; reasoning: "每个Context明确管理自己的数据"  
    issues: []

  # ═══ Phase 2：战术架构 ═══
  aggregates:
  - aggregate_id: "AGG-001"; aggregate_name: "TaskBook"; context: "CTX-001"; aggregate_root: "TaskBook"; consistency_boundary: "任务书+基础素质指标+专业素质指标在同一事务"; reasoning: "任务书和指标占比必须原子性校验(和=100%)"
    entities:
    - entity_id: "ENT-001"; entity_name: "TaskBook"; is_aggregate_root: true; business_behaviors: [{method:"edit(mentor)",triggers_event:"EVT-002"},{method:"confirm(trainee)",triggers_event:"EVT-003"},{method:"approve(chief)",triggers_event:"EVT-004"}]; ownership_fields: [{field:"employee_name"},{field:"department"},{field:"contract_period"},{field:"employee_no"},{field:"entry_date"},{field:"probation_end_date"},{field:"entry_path"},{field:"proposed_position"}]
    - entity_id: "ENT-002"; entity_name: "BasicQualityIndicator"; is_aggregate_root: false; ownership_fields: [{field:"indicator_name"},{field:"description"},{field:"ratio"},{field:"scoring_method"},{field:"score"},{field:"remark"}]
    - entity_id: "ENT-003"; entity_name: "ProfessionalQualityIndicator"; is_aggregate_root: false; ownership_fields: [{field:"indicator_name"},{field:"description"},{field:"ratio"},{field:"scoring_method"},{field:"score"}]
    value_objects:
    - vo_id: "VO-001"; vo_name: "Ratio"; attributes: ["value"]; reasoning: "占比值0-100，不可变，需要校验总和=100"

  - aggregate_id: "AGG-002"; aggregate_name: "ProbationAssessment"; context: "CTX-001"; aggregate_root: "ProbationAssessment"; consistency_boundary: "考核记录+四个模块+评分+考核结果"; reasoning: "考核提交为事务边界"
    entities:
    - entity_id: "ENT-004"; entity_name: "ProbationAssessment"; is_aggregate_root: true; business_behaviors: [{method:"launch(hr)",triggers_event:"EVT-005"},{method:"fillSummary(trainee)",triggers_event:"EVT-006"},{method:"score(mentor)",triggers_event:"EVT-007"},{method:"review(chief/dept_mgr)",triggers_event:"EVT-008"},{method:"archive(hr)",triggers_event:"EVT-009"}]; ownership_fields: [{field:"training_completion"},{field:"task_completion"},{field:"shortcomings"},{field:"others"},{field:"assessment_result"},{field:"overall_evaluation"}]
    domain_events:
    - event_id: "DE-001"; event_name: "AssessmentRejected"; source_aggregate: "AGG-002"; trigger: "审核退回"; consumers: ["CTX-008"]; payload: [{field:"assessment_id"},{field:"reject_reason"}]

  - aggregate_id: "AGG-003"; aggregate_name: "PositionAppointment"; context: "CTX-002"; aggregate_root: "PositionAppointment"; consistency_boundary: "聘任申请+员工子表+评审会信息"; reasoning: "同一次聘任的申请、员工、评审信息在同一事务"
    entities:
    - entity_id: "ENT-005"; entity_name: "PositionAppointment"; is_aggregate_root: true; business_behaviors: [{method:"initiate(org_planner)",triggers_event:"EVT-010"},{method:"organizeReview(eng_trainer)",triggers_event:"EVT-011"},{method:"score(eng_trainer)",triggers_event:"EVT-012"},{method:"approve(reviewer)",triggers_event:"EVT-013"},{method:"reject(reviewer)",triggers_event:"EVT-014"}]; ownership_fields: [{field:"promotion_type"},{field:"initiator"},{field:"department"},{field:"initiate_date"}]
    - entity_id: "ENT-006"; entity_name: "AppointmentEmployee"; is_aggregate_root: false; ownership_fields: [{field:"employee_name"},{field:"employee_no"},{field:"department"},{field:"rank"},{field:"qualification_level"},{field:"current_rank_tenure"},{field:"authorization_attachment"},{field:"recent_performance"},{field:"review_score"}]; foreign_references: [{field:"employee_id",references:"EmployeeContext.Employee.id"}]
    - entity_id: "ENT-007"; entity_name: "ReviewMeeting"; is_aggregate_root: false; ownership_fields: [{field:"reviewers"},{field:"review_time"},{field:"review_result"}]
    domain_events:
    - event_id: "DE-002"; event_name: "AppointmentRejected"; source_aggregate: "AGG-003"; trigger: "聘任被退回"; consumers: ["CTX-008"]

  - aggregate_id: "AGG-004"; aggregate_name: "SeniorTaskBook"; context: "CTX-002"; aggregate_root: "SeniorTaskBook"; consistency_boundary: "高级任务书+关键业绩承诺书"; reasoning: "任务书和业绩承诺同一事务"
    entities:
    - entity_id: "ENT-008"; entity_name: "SeniorTaskBook"; is_aggregate_root: true; business_behaviors: [{method:"create(employee)",triggers_event:"EVT-015"},{method:"approve(hr/dept_mgr/vp)",triggers_event:"EVT-016"}]; ownership_fields: [{field:"employee_no"},{field:"employee_name"},{field:"department"},{field:"position_name"},{field:"initiate_date"},{field:"approval_status"}]
    - entity_id: "ENT-009"; entity_name: "PerformanceCommitment"; is_aggregate_root: false; ownership_fields: [{field:"dimension"},{field:"content"},{field:"target"},{field:"source"}]

  - aggregate_id: "AGG-005"; aggregate_name: "SeniorAssessment"; context: "CTX-002"; aggregate_root: "SeniorAssessment"; consistency_boundary: "高级考核+述职述廉报告"; reasoning: "任务书通过后自动生成，报告+打分+归档"
    entities:
    - entity_id: "ENT-010"; entity_name: "SeniorAssessment"; is_aggregate_root: true; business_behaviors: [{method:"fillReport(employee)",triggers_event:"EVT-017"},{method:"score(dept_mgr)",triggers_event:"EVT-018"}]; ownership_fields: [{field:"basic_info"},{field:"ideology"},{field:"performance"},{field:"talent_dev"},{field:"integrity"},{field:"shortcomings"},{field:"next_plan"}]

  - aggregate_id: "AGG-006"; aggregate_name: "TitleDetermination"; context: "CTX-003"; aggregate_root: "TitleDetermination"; consistency_boundary: "职称初定申请"; reasoning: "初定申请+审批在同一事务"
    entities:
    - entity_id: "ENT-015"; entity_name: "TitleDetermination"; is_aggregate_root: true; business_behaviors: [{method:"initiate(hr)",triggers_event:"EVT-022"},{method:"fill(employee)",triggers_event:"EVT-023"},{method:"approve(chain)",triggers_event:"EVT-024"}]; ownership_fields: [{field:"employee_name"},{field:"birth_date"},{field:"ethnicity"},{field:"political_status"},{field:"highest_degree"},{field:"school"},{field:"major"},{field:"degree"},{field:"photo"},{field:"foreign_language"},{field:"learning_experience"}]

  - aggregate_id: "AGG-007"; aggregate_name: "TitleReview"; context: "CTX-003"; aggregate_root: "TitleReview"; consistency_boundary: "职称评审申报+多子表"; reasoning: "评审申报含多子表，整体提交"
    entities:
    - entity_id: "ENT-016"; entity_name: "TitleReview"; is_aggregate_root: true; business_behaviors: [{method:"apply(employee)",triggers_event:"EVT-025"},{method:"review(reviewer)",triggers_event:"EVT-026"}]; ownership_fields: [{field:"basic_info"},{field:"current_title"},{field:"work_start_date"}]
    - entity_id: "ENT-017"; entity_name: "TrainingExperience"; is_aggregate_root: false; ownership_fields: [{field:"period"},{field:"content"},{field:"location"},{field:"witness"}]
    - entity_id: "ENT-018"; entity_name: "WorkExperience"; is_aggregate_root: false; ownership_fields: [{field:"period"},{field:"unit"},{field:"work"},{field:"position"}]
    - entity_id: "ENT-019"; entity_name: "AchievementRecord"; is_aggregate_root: false; ownership_fields: [{field:"period"},{field:"project_name"},{field:"content"},{field:"role"},{field:"result"}]
    - entity_id: "ENT-020"; entity_name: "Publication"; is_aggregate_root: false; ownership_fields: [{field:"date"},{field:"title"},{field:"publication_info"},{field:"authorship"}]
    - entity_id: "ENT-021"; entity_name: "ExamScore"; is_aggregate_root: false; ownership_fields: [{field:"date"},{field:"exam_type"},{field:"subject"},{field:"score"},{field:"organizer"}]

  - aggregate_id: "AGG-008"; aggregate_name: "Mentor"; context: "CTX-004"; aggregate_root: "Mentor"; consistency_boundary: "导师+徒弟"; reasoning: "导师和徒弟结对强关联"
    entities:
    - entity_id: "ENT-011"; entity_name: "Mentor"; is_aggregate_root: true; business_behaviors: [{method:"maintain(hr)",triggers_event:"EVT-019"}]; ownership_fields: [{field:"employee_no"},{field:"name"},{field:"highest_degree"},{field:"position_category"},{field:"position_level"},{field:"position_name"},{field:"position_start_date"},{field:"work_start_date"},{field:"title"},{field:"manager_level"}]
    - entity_id: "ENT-012"; entity_name: "Mentee"; is_aggregate_root: false; ownership_fields: [{field:"mentee_name"},{field:"mentee_no"},{field:"pairing_start_date"},{field:"gifted_book"},{field:"status"}]

  - aggregate_id: "AGG-009"; aggregate_name: "BookLibrary"; context: "CTX-004"; aggregate_root: "Book"; consistency_boundary: "书库+赠书记录"; reasoning: "书籍和赠书记录强关联(库存联动)"
    entities:
    - entity_id: "ENT-013"; entity_name: "Book"; is_aggregate_root: true; business_behaviors: [{method:"add(hr)",triggers_event:"EVT-021"},{method:"giftRecord(hr)",triggers_event:"EVT-020"}]; ownership_fields: [{field:"book_name"},{field:"category"},{field:"total_qty"},{field:"gifted_qty"},{field:"remaining_qty"}]
    - entity_id: "ENT-014"; entity_name: "GiftRecord"; is_aggregate_root: false; ownership_fields: [{field:"mentor_name"},{field:"gift_date"},{field:"recipient"}]

  - aggregate_id: "AGG-010"; aggregate_name: "ArchiveTransfer"; context: "CTX-005"; aggregate_root: "ArchiveTransfer"; consistency_boundary: "档案转入归档"; reasoning: "单一的申请实体"
    entities:
    - entity_id: "ENT-022"; entity_name: "ArchiveTransfer"; is_aggregate_root: true; business_behaviors: [{method:"apply(employee/dept_mgr)",triggers_event:"EVT-027"},{method:"approve(hr)",triggers_event:"EVT-028"}]; ownership_fields: [{field:"employee_no"},{field:"employee_name"},{field:"department"},{field:"application_type"},{field:"archive_source"},{field:"material_count"},{field:"application_date"},{field:"archive_date"}]

  - aggregate_id: "AGG-011"; aggregate_name: "InfoAccessRequest"; context: "CTX-006"; aggregate_root: "InfoAccessRequest"; consistency_boundary: "信息使用申请+权限"; reasoning: "申请和权限授予紧密关联"
    entities:
    - entity_id: "ENT-023"; entity_name: "InfoAccessRequest"; is_aggregate_root: true; business_behaviors: [{method:"apply(employee)",triggers_event:"EVT-029"},{method:"approve(chain)",triggers_event:"EVT-030"}]; ownership_fields: [{field:"applicant_name"},{field:"applicant_no"},{field:"department"},{field:"application_date"},{field:"is_sensitive"},{field:"sensitivity_level"},{field:"approval_status"},{field:"access_validity_period"},{field:"access_log"}]

  - aggregate_id: "AGG-012"; aggregate_name: "Dashboard"; context: "CTX-007"; aggregate_root: "DashboardConfig"; consistency_boundary: "大屏配置"; reasoning: "配置实体"
    entities:
    - entity_id: "ENT-024"; entity_name: "DashboardConfig"; is_aggregate_root: true; ownership_fields: [{field:"metric_type"},{field:"data_source"},{field:"refresh_frequency"},{field:"chart_type"}]

  - aggregate_id: "AGG-013"; aggregate_name: "Notification"; context: "CTX-008"; aggregate_root: "NotificationTemplate"; consistency_boundary: "通知模板+发送记录"; reasoning: "通知管理"
    entities:
    - entity_id: "ENT-025"; entity_name: "NotificationTemplate"; is_aggregate_root: true; business_behaviors: [{method:"send(system)",triggers_event:"EVT-031"}]; ownership_fields: [{field:"template_name"},{field:"channel"},{field:"content_template"}]

  services:
  - service_id: "SVC-001"; service_name: "probation-service"; context: "CTX-001"; service_type: "core"; aggregates: ["AGG-001","AGG-002"]; reasoning: "任务书+考核强关联，同服务维护一致性"
  - service_id: "SVC-002"; service_name: "appointment-service"; context: "CTX-002"; service_type: "core"; aggregates: ["AGG-003","AGG-004","AGG-005"]; reasoning: "聘任+高级任务书+高级考核属于同一业务域"
  - service_id: "SVC-003"; service_name: "title-service"; context: "CTX-003"; service_type: "core"; aggregates: ["AGG-006","AGG-007"]; reasoning: "职称初定+评审统一管理"
  - service_id: "SVC-004"; service_name: "mentor-service"; context: "CTX-004"; service_type: "supporting"; aggregates: ["AGG-008","AGG-009"]; reasoning: "导师库+书库在同一支撑域"
  - service_id: "SVC-005"; service_name: "archive-service"; context: "CTX-005"; service_type: "supporting"; aggregates: ["AGG-010"]; reasoning: "档案管理独立服务"
  - service_id: "SVC-006"; service_name: "security-service"; context: "CTX-006"; service_type: "supporting"; aggregates: ["AGG-011"]; reasoning: "信息安全独立服务，含权限管控"
  - service_id: "SVC-007"; service_name: "dashboard-service"; context: "CTX-007"; service_type: "supporting"; aggregates: ["AGG-012"]; reasoning: "大屏独立服务"
  - service_id: "SVC-008"; service_name: "notification-service"; context: "CTX-008"; service_type: "generic"; aggregates: ["AGG-013"]; reasoning: "统一通知服务，全系统复用"

  # ─── 跨Context领域服务（横切关注点，非独立BC）───
  domain_services:
  - service_name: "ApprovalService"; description: "统一审批服务，管理审批链、状态流转、退回处理"; used_by: ["CTX-001","CTX-002","CTX-003","CTX-005","CTX-006"]; pattern: "domain_service"; reasoning: "横切关注点，作为领域服务而非独立Context"
  - service_name: "OrganizationService"; description: "组织架构服务，提供部门树、数据范围计算"; used_by: ["*"]; pattern: "domain_service"; reasoning: "基础数据服务，支撑数据权限隔离"

  communication:
  - from_service: "SVC-001"; to_service: "SVC-008"; protocol: "async_event"; pattern: "OHS"; events: ["AssessmentRejected","TaskBookApproved"]
  - from_service: "SVC-002"; to_service: "SVC-008"; protocol: "async_event"; pattern: "OHS"; events: ["AppointmentRejected"]
  - from_service: "SVC-001"; to_service: "SVC-007"; protocol: "async_event"; pattern: "OHS"; events: ["AssessmentArchived"]

  architecture_patterns:
    cqrs: {enabled: false, reasoning: "读写差异不大，不需要CQRS"}
    event_driven: {enabled: true, reasoning: "通知和大屏需要异步订阅状态变更事件，解耦核心域和支撑域"}
    layers:
    - name: "Interface Layer"; components: ["Controller","DTO","Assembler"]
    - name: "Application Layer"; components: ["ApplicationService","UseCase","ApprovalService(domain_service)"]; rule: "协调领域对象+审批流编排"
    - name: "Domain Layer"; components: ["AggregateRoot","Entity","ValueObject","DomainEvent","Repository Interface"]; rule: "核心业务逻辑"
    - name: "Infrastructure Layer"; components: ["Repository Impl","MessagePublisher","OrgTreeAdapter"]; rule: "技术实现"

  architecture_validation:
    core_independent: true; reasoning: "核心服务(probation/appointment/title)只生成事件，不依赖其他核心服务"
    no_circular_deps: true; reasoning: "所有通信为单向异步事件"
    domain_no_infra_deps: true; reasoning: "领域层通过接口隔离基础设施"
    context_service_alignment: true; reasoning: "8个Context映射8个服务，1:1"

  coverage:
    all_domains_classified: true
    all_contexts_bounded: true
    all_aggregates_defined: true
    all_services_mapped: true
    language_consistent: true
```
