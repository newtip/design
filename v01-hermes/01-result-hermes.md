# Agent 01 — Requirement Refinement Result (Hermes)

## 苍南二期人事系统 — Business Model

```yaml
business_model:
  project_name: "苍南二期人事系统"
  business_goal: "实现技术岗位聘任、试用期考核、人事管理、干部导师库的全面线上化，达成流程标准化、数据集中化、权限精细化、提醒自动化"
  requirement_maturity_quick:
    completeness: "high"
    clarity: "high"
    consistency: "high"
    open_issues_flagged: true

  # ═══════════════════════════════════════════
  # Channel A：事件风暴
  # ═══════════════════════════════════════════
  event_storming:
    commands:
    - cmd_id: "CMD-001"; command_name: "SyncProbationData"; actor: "系统/培训系统"; triggers_event: "EVT-001"; description: "培训系统师徒协议通过后同步数据到人资系统"
    - cmd_id: "CMD-002"; command_name: "EditTaskBook"; actor: "师傅"; triggers_event: "EVT-002"; description: "师傅编辑试用期考核任务书"; related_functions: ["FUNC-001"]
    - cmd_id: "CMD-003"; command_name: "ConfirmTaskBook"; actor: "徒弟"; triggers_event: "EVT-003"; description: "徒弟确认任务书"; related_functions: ["FUNC-001"]
    - cmd_id: "CMD-004"; command_name: "ApproveTaskBook"; actor: "科长"; triggers_event: "EVT-004"; description: "科长审核任务书"; related_functions: ["FUNC-001"]
    - cmd_id: "CMD-005"; command_name: "LaunchProbationAssessment"; actor: "人资"; triggers_event: "EVT-005"; description: "人资批量发起试用期考核"; related_functions: ["FUNC-002"]
    - cmd_id: "CMD-006"; command_name: "FillWorkSummary"; actor: "徒弟"; triggers_event: "EVT-006"; description: "徒弟填写四模块工作小结"; related_functions: ["FUNC-002"]
    - cmd_id: "CMD-007"; command_name: "ScoreAssessment"; actor: "师傅"; triggers_event: "EVT-007"; description: "师傅评分并给出考核结果"; related_functions: ["FUNC-002"]
    - cmd_id: "CMD-008"; command_name: "ReviewAssessment"; actor: "科长/部门经理"; triggers_event: "EVT-008"; description: "科长/部门经理逐级审核考核"; related_functions: ["FUNC-002"]
    - cmd_id: "CMD-009"; command_name: "ArchiveAssessment"; actor: "人资"; triggers_event: "EVT-009"; description: "人资归档考核结果"; related_functions: ["FUNC-002"]
    - cmd_id: "CMD-010"; command_name: "LaunchPositionAppointment"; actor: "组织规划管理员"; triggers_event: "EVT-010"; description: "发起技术岗位集中聘任"; related_functions: ["FUNC-003"]
    - cmd_id: "CMD-011"; command_name: "OrganizeReviewMeeting"; actor: "培训工程师"; triggers_event: "EVT-011"; description: "组织评审会"; related_functions: ["FUNC-003"]
    - cmd_id: "CMD-012"; command_name: "ScoreCandidates"; actor: "培训工程师"; triggers_event: "EVT-012"; description: "培训工程师给参评人员打分"; related_functions: ["FUNC-003"]
    - cmd_id: "CMD-013"; command_name: "ApproveAppointment"; actor: "部门经理/人资/高评委/党委会"; triggers_event: "EVT-013"; description: "逐级审批聘任"; related_functions: ["FUNC-003"]
    - cmd_id: "CMD-014"; command_name: "RejectAppointment"; actor: "部门经理/人资"; triggers_event: "EVT-014"; description: "退回/不同意聘任"; related_functions: ["FUNC-003"]
    - cmd_id: "CMD-015"; command_name: "CreateSeniorTaskBook"; actor: "正式员工"; triggers_event: "EVT-015"; description: "发起高级技术岗位任务书"; related_functions: ["FUNC-004"]
    - cmd_id: "CMD-016"; command_name: "ApproveSeniorTaskBook"; actor: "人资/部门经理/分管领导"; triggers_event: "EVT-016"; description: "审批高级岗位任务书"; related_functions: ["FUNC-004"]
    - cmd_id: "CMD-017"; command_name: "FillDutyReport"; actor: "员工"; triggers_event: "EVT-017"; description: "员工填写述职述廉报告"; related_functions: ["FUNC-005"]
    - cmd_id: "CMD-018"; command_name: "ScoreSeniorAssessment"; actor: "部门经理"; triggers_event: "EVT-018"; description: "部门经理打分"; related_functions: ["FUNC-005"]
    - cmd_id: "CMD-019"; command_name: "MaintainMentorInfo"; actor: "人资"; triggers_event: "EVT-019"; description: "维护干部导师库"; related_functions: ["FUNC-006"]
    - cmd_id: "CMD-020"; command_name: "RecordBookGift"; actor: "人资"; triggers_event: "EVT-020"; description: "记录赠书"; related_functions: ["FUNC-006","FUNC-007"]
    - cmd_id: "CMD-021"; command_name: "MaintainBookLibrary"; actor: "人资"; triggers_event: "EVT-021"; description: "维护导师书库"; related_functions: ["FUNC-007"]
    - cmd_id: "CMD-022"; command_name: "InitiateTitleDetermination"; actor: "人资"; triggers_event: "EVT-022"; description: "发起职称初定流程"; related_functions: ["FUNC-008"]
    - cmd_id: "CMD-023"; command_name: "FillTitleDetermination"; actor: "员工"; triggers_event: "EVT-023"; description: "员工填写职称初定材料"; related_functions: ["FUNC-008"]
    - cmd_id: "CMD-024"; command_name: "ApproveTitleDetermination"; actor: "科长/部门经理/人资部门经理"; triggers_event: "EVT-024"; description: "逐级审核职称初定"; related_functions: ["FUNC-008"]
    - cmd_id: "CMD-025"; command_name: "ApplyTitleReview"; actor: "正式员工"; triggers_event: "EVT-025"; description: "员工申报职称评审"; related_functions: ["FUNC-009"]
    - cmd_id: "CMD-026"; command_name: "ReviewTitleApplication"; actor: "人资/部门经理/组长/主任"; triggers_event: "EVT-026"; description: "评审职称申报"; related_functions: ["FUNC-009"]
    - cmd_id: "CMD-027"; command_name: "ApplyArchiveTransfer"; actor: "员工/部门经理"; triggers_event: "EVT-027"; description: "人事档案转入归档申请"; related_functions: ["FUNC-010"]
    - cmd_id: "CMD-028"; command_name: "ApproveArchiveTransfer"; actor: "人资管理员"; triggers_event: "EVT-028"; description: "审批档案转入归档"; related_functions: ["FUNC-010"]
    - cmd_id: "CMD-029"; command_name: "ApplyInfoAccess"; actor: "员工"; triggers_event: "EVT-029"; description: "人力资源信息使用申请"; related_functions: ["FUNC-011"]
    - cmd_id: "CMD-030"; command_name: "ApproveInfoAccess"; actor: "科长/部门经理/人资科长/人资部门经理"; triggers_event: "EVT-030"; description: "分级审批信息使用"; related_functions: ["FUNC-011"]
    - cmd_id: "CMD-031"; command_name: "TriggerHolidayReminder"; actor: "系统/数据中台"; triggers_event: "EVT-031"; description: "系统定时触发假期提醒"; related_functions: ["FUNC-012"]
    - cmd_id: "CMD-032"; command_name: "SyncDashboardData"; actor: "系统"; triggers_event: "EVT-032"; description: "同步大屏数据"; related_functions: ["FUNC-013","FUNC-014","FUNC-015"]

    events:
    - event_id: "EVT-001"; event_name: "ProbationDataSynced"; source_command: "CMD-001"; description: "培训系统师徒协议数据同步完成"; triggers: {policies: ["POL-001"], next_events: ["EVT-002"]}
    - event_id: "EVT-002"; event_name: "TaskBookEdited"; source_command: "CMD-002"; description: "师傅编辑任务书完成"; triggers: {next_events: ["EVT-003"]}
    - event_id: "EVT-003"; event_name: "TaskBookConfirmed"; source_command: "CMD-003"; description: "徒弟确认任务书"; triggers: {next_events: ["EVT-004"]}
    - event_id: "EVT-004"; event_name: "TaskBookApproved"; source_command: "CMD-004"; description: "科长审核通过任务书"; triggers: {policies: ["POL-002"]}
    - event_id: "EVT-005"; event_name: "ProbationAssessmentLaunched"; source_command: "CMD-005"; description: "人资批量发起试用期考核"; triggers: {next_events: ["EVT-006"]}
    - event_id: "EVT-006"; event_name: "WorkSummaryFilled"; source_command: "CMD-006"; description: "徒弟填写工作小结"; triggers: {next_events: ["EVT-007"]}
    - event_id: "EVT-007"; event_name: "AssessmentScored"; source_command: "CMD-007"; description: "师傅评分并给出考核结果"; triggers: {next_events: ["EVT-008"]}
    - event_id: "EVT-008"; event_name: "AssessmentReviewed"; source_command: "CMD-008"; description: "科长/部门经理审核考核"; triggers: {next_events: ["EVT-009"]}
    - event_id: "EVT-009"; event_name: "AssessmentArchived"; source_command: "CMD-009"; description: "考核结果归档"; triggers: {}
    - event_id: "EVT-010"; event_name: "PositionAppointmentInitiated"; source_command: "CMD-010"; description: "技术岗位聘任流程启动"; triggers: {policies: ["POL-003","POL-004","POL-005","POL-006"], next_events: ["EVT-011"]}
    - event_id: "EVT-011"; event_name: "ReviewMeetingOrganized"; source_command: "CMD-011"; description: "评审会组织完成"; triggers: {next_events: ["EVT-012"]}
    - event_id: "EVT-012"; event_name: "CandidatesScored"; source_command: "CMD-012"; description: "参评人员打分完成"; triggers: {next_events: ["EVT-013"]}
    - event_id: "EVT-013"; event_name: "AppointmentApproved"; source_command: "CMD-013"; description: "聘任审批通过"; triggers: {policies: ["POL-007"]}
    - event_id: "EVT-014"; event_name: "AppointmentRejected"; source_command: "CMD-014"; description: "聘任被退回/不同意"; triggers: {}
    - event_id: "EVT-015"; event_name: "SeniorTaskBookCreated"; source_command: "CMD-015"; description: "高级岗位任务书创建"; triggers: {next_events: ["EVT-016"]}
    - event_id: "EVT-016"; event_name: "SeniorTaskBookApproved"; source_command: "CMD-016"; description: "高级岗位任务书审批通过"; triggers: {policies: ["POL-008"], next_events: ["EVT-017"]}
    - event_id: "EVT-017"; event_name: "DutyReportFilled"; source_command: "CMD-017"; description: "述职述廉报告填写完成"; triggers: {next_events: ["EVT-018"]}
    - event_id: "EVT-018"; event_name: "SeniorAssessmentScored"; source_command: "CMD-018"; description: "高级岗位考核打分完成"; triggers: {}
    - event_id: "EVT-019"; event_name: "MentorInfoMaintained"; source_command: "CMD-019"; description: "导师信息维护完成"; triggers: {}
    - event_id: "EVT-020"; event_name: "BookGiftRecorded"; source_command: "CMD-020"; description: "赠书记录保存"; triggers: {policies: ["POL-009"]}
    - event_id: "EVT-021"; event_name: "BookLibraryUpdated"; source_command: "CMD-021"; description: "书库信息更新"; triggers: {}
    - event_id: "EVT-022"; event_name: "TitleDeterminationInitiated"; source_command: "CMD-022"; description: "职称初定流程启动"; triggers: {next_events: ["EVT-023"]}
    - event_id: "EVT-023"; event_name: "TitleDeterminationFilled"; source_command: "CMD-023"; description: "职称初定材料填写完成"; triggers: {next_events: ["EVT-024"]}
    - event_id: "EVT-024"; event_name: "TitleDeterminationApproved"; source_command: "CMD-024"; description: "职称初定审批通过"; triggers: {}
    - event_id: "EVT-025"; event_name: "TitleReviewApplied"; source_command: "CMD-025"; description: "职称评审申报提交"; triggers: {next_events: ["EVT-026"]}
    - event_id: "EVT-026"; event_name: "TitleReviewCompleted"; source_command: "CMD-026"; description: "职称评审完成"; triggers: {policies: ["POL-010"]}
    - event_id: "EVT-027"; event_name: "ArchiveTransferApplied"; source_command: "CMD-027"; description: "档案转入归档申请提交"; triggers: {next_events: ["EVT-028"]}
    - event_id: "EVT-028"; event_name: "ArchiveTransferApproved"; source_command: "CMD-028"; description: "档案转入归档审批通过"; triggers: {}
    - event_id: "EVT-029"; event_name: "InfoAccessApplied"; source_command: "CMD-029"; description: "信息使用申请提交"; triggers: {next_events: ["EVT-030"]}
    - event_id: "EVT-030"; event_name: "InfoAccessApproved"; source_command: "CMD-030"; description: "信息使用审批通过（自动授权+有效期）"; triggers: {policies: ["POL-011"]}
    - event_id: "EVT-031"; event_name: "HolidayReminderSent"; source_command: "CMD-031"; description: "假期提醒已发送"; triggers: {}
    - event_id: "EVT-032"; event_name: "DashboardDataRefreshed"; source_command: "CMD-032"; description: "大屏数据刷新完成"; triggers: {}

    policies:
    - policy_id: "POL-001"; policy_name: "GenerateTaskBookTodo"; triggered_by: "EVT-001"; description: "同步后自动生成师傅待办数据"; type: "synchronous"
    - policy_id: "POL-002"; policy_name: "ValidateTaskBookRatio"; triggered_by: "EVT-003"; description: "校验所有占比之和等于100%"; type: "synchronous"; related_rules: ["RULE-005"]
    - policy_id: "POL-003"; policy_name: "FilterJuniorCandidates"; triggered_by: "EVT-010"; description: "按中初级晋升条件筛选候选人"; type: "synchronous"
    - policy_id: "POL-004"; policy_name: "FilterMeritCandidates"; triggered_by: "EVT-010"; description: "按绩优晋升条件筛选候选人"; type: "synchronous"
    - policy_id: "POL-005"; policy_name: "FilterExceptionCandidates"; triggered_by: "EVT-010"; description: "按破格越级晋升条件筛选候选人"; type: "synchronous"
    - policy_id: "POL-006"; policy_name: "FilterSeniorCandidates"; triggered_by: "EVT-010"; description: "按高级晋升条件筛选候选人"; type: "synchronous"
    - policy_id: "POL-007"; policy_name: "UpdateAppointmentLedger"; triggered_by: "EVT-013"; description: "审批通过后更新聘任台账"; type: "synchronous"
    - policy_id: "POL-008"; policy_name: "AutoGenerateAssessment"; triggered_by: "EVT-016"; description: "任务书审批通过后自动生成考核编辑数据"; type: "synchronous"
    - policy_id: "POL-009"; policy_name: "UpdateBookInventory"; triggered_by: "EVT-020"; description: "赠书后自动更新书库库存"; type: "synchronous"
    - policy_id: "POL-010"; policy_name: "PublishAnnouncement"; triggered_by: "EVT-026"; description: "评审通过后公示发文"; type: "asynchronous"
    - policy_id: "POL-011"; policy_name: "GrantAccessWithExpiry"; triggered_by: "EVT-030"; description: "审批通过后按有效期授予数据访问权限"; type: "synchronous"; related_rules: ["RULE-016","RULE-017"]

    event_flows:
    - flow_id: "FLOW-001"; flow_name: "试用期考核任务书签订"; flow_type: "primary"; description: "培训系统协议通过→师傅编辑→徒弟确认→科长审核→生效"; steps: [{type:"command",ref:"CMD-001",actor:"系统"},{type:"event",ref:"EVT-001"},{type:"command",ref:"CMD-002",actor:"师傅"},{type:"event",ref:"EVT-002"},{type:"command",ref:"CMD-003",actor:"徒弟"},{type:"event",ref:"EVT-003"},{type:"policy",ref:"POL-002"},{type:"command",ref:"CMD-004",actor:"科长"},{type:"event",ref:"EVT-004"}]
    - flow_id: "FLOW-002"; flow_name: "试用期考核"; flow_type: "primary"; description: "人资批量发起→徒弟填写小结→师傅评分→科长审核→部门经理审核→人资归档"; steps: [{type:"command",ref:"CMD-005",actor:"人资"},{type:"event",ref:"EVT-005"},{type:"command",ref:"CMD-006",actor:"徒弟"},{type:"event",ref:"EVT-006"},{type:"command",ref:"CMD-007",actor:"师傅"},{type:"event",ref:"EVT-007"},{type:"command",ref:"CMD-008",actor:"科长/部门经理"},{type:"event",ref:"EVT-008"},{type:"command",ref:"CMD-009",actor:"人资"},{type:"event",ref:"EVT-009"}]
    - flow_id: "FLOW-003"; flow_name: "技术岗位集中聘任(中初级)"; flow_type: "primary"; description: "组织规划管理员发起→培训工程师授权→组织评审会→打分→部门经理审核→人资审核"; steps: [{type:"command",ref:"CMD-010",actor:"组织规划管理员"},{type:"event",ref:"EVT-010"},{type:"policy",ref:"POL-003"},{type:"command",ref:"CMD-011",actor:"培训工程师"},{type:"event",ref:"EVT-011"},{type:"command",ref:"CMD-012",actor:"培训工程师"},{type:"event",ref:"EVT-012"},{type:"command",ref:"CMD-013",actor:"部门经理/人资"},{type:"event",ref:"EVT-013"}]
    - flow_id: "FLOW-004"; flow_name: "技术岗位聘任(破格/高级)"; flow_type: "primary"; description: "同中初级但增加高评委审议和党委会审批"; steps: [{type:"command",ref:"CMD-010"},{type:"event",ref:"EVT-010"},{type:"command",ref:"CMD-013",actor:"高评委"},{type:"command",ref:"CMD-013",actor:"党委会"},{type:"event",ref:"EVT-013"}]
    - flow_id: "FLOW-005"; flow_name: "高级技术岗位任务书+考核"; flow_type: "primary"; description: "员工发起→人资审核→部门经理→分管领导审批→自动生成考核→员工填写报告→部门经理打分→人资归档"; steps: [{type:"command",ref:"CMD-015",actor:"员工"},{type:"event",ref:"EVT-015"},{type:"command",ref:"CMD-016",actor:"人资/部门经理/分管领导"},{type:"event",ref:"EVT-016"},{type:"policy",ref:"POL-008"},{type:"command",ref:"CMD-017",actor:"员工"},{type:"event",ref:"EVT-017"},{type:"command",ref:"CMD-018",actor:"部门经理"},{type:"event",ref:"EVT-018"}]
    - flow_id: "FLOW-006"; flow_name: "职称初定"; flow_type: "primary"; description: "人资筛选发起→员工填写→人资审核→科长审核→部门审核→人资部门经理审核→归档"; steps: [{type:"command",ref:"CMD-022",actor:"人资"},{type:"event",ref:"EVT-022"},{type:"command",ref:"CMD-023",actor:"员工"},{type:"event",ref:"EVT-023"},{type:"command",ref:"CMD-024",actor:"人资/科长/部门经理/人资部门经理"},{type:"event",ref:"EVT-024"}]
    - flow_id: "FLOW-007"; flow_name: "职称评审"; flow_type: "primary"; description: "员工申报→人资审核→部门经理审核→组长评审→主任评审→人资部门经理审核→公示发文"; steps: [{type:"command",ref:"CMD-025",actor:"员工"},{type:"event",ref:"EVT-025"},{type:"command",ref:"CMD-026",actor:"人资/部门经理/组长/主任"},{type:"event",ref:"EVT-026"},{type:"policy",ref:"POL-010"}]
    - flow_id: "FLOW-008"; flow_name: "人事档案转入归档"; flow_type: "supporting"; description: "发起→审批→归档"; steps: [{type:"command",ref:"CMD-027",actor:"员工/部门经理"},{type:"event",ref:"EVT-027"},{type:"command",ref:"CMD-028",actor:"人资"},{type:"event",ref:"EVT-028"}]
    - flow_id: "FLOW-009"; flow_name: "人力资源信息使用申请"; flow_type: "supporting"; description: "员工发起→按敏感等级分级审批→授权+有效期"; steps: [{type:"command",ref:"CMD-029",actor:"员工"},{type:"event",ref:"EVT-029"},{type:"command",ref:"CMD-030",actor:"多级审批"},{type:"event",ref:"EVT-030"},{type:"policy",ref:"POL-011"}]
    - flow_id: "FLOW-010"; flow_name: "干部导师库+书库管理"; flow_type: "supporting"; description: "人资维护导师信息+徒弟结对+赠书记录→书库库存自动更新"; steps: [{type:"command",ref:"CMD-019",actor:"人资"},{type:"event",ref:"EVT-019"},{type:"command",ref:"CMD-020",actor:"人资"},{type:"event",ref:"EVT-020"},{type:"policy",ref:"POL-009"}]
    - flow_id: "FLOW-011"; flow_name: "假期提醒"; flow_type: "integration"; description: "中台数据同步→按规则触发→钉钉/邮件通知"; steps: [{type:"command",ref:"CMD-031",actor:"系统"},{type:"event",ref:"EVT-031"}]
    - flow_id: "FLOW-012"; flow_name: "人事大屏数据刷新"; flow_type: "integration"; description: "SAP/HR同步→自动统计→大屏展示"; steps: [{type:"command",ref:"CMD-032",actor:"系统"},{type:"event",ref:"EVT-032"}]

  capability_map:
  - cap_id: "CAP-001"; name: "试用期考核管理"; type: "core"; commands: ["CMD-002","CMD-003","CMD-004","CMD-005","CMD-006","CMD-007","CMD-008","CMD-009"]; events: ["EVT-002","EVT-003","EVT-004","EVT-005","EVT-006","EVT-007","EVT-008","EVT-009"]; reasoning: "核心人事流程，直接支撑试用期员工考核与转正决策"
  - cap_id: "CAP-002"; name: "技术岗位聘任管理"; type: "core"; commands: ["CMD-010","CMD-011","CMD-012","CMD-013","CMD-014"]; events: ["EVT-010","EVT-011","EVT-012","EVT-013","EVT-014"]; reasoning: "公司核心人才晋升机制，涉及5种晋升类型+评审会+多级审批"
  - cap_id: "CAP-003"; name: "高级技术岗位管理"; type: "core"; commands: ["CMD-015","CMD-016","CMD-017","CMD-018"]; events: ["EVT-015","EVT-016","EVT-017","EVT-018"]; reasoning: "高级人才管理，涉及任务书签订+述职述廉+分管领导审批"
  - cap_id: "CAP-004"; name: "职称管理"; type: "core"; commands: ["CMD-022","CMD-023","CMD-024","CMD-025","CMD-026"]; events: ["EVT-022","EVT-023","EVT-024","EVT-025","EVT-026"]; reasoning: "职称初定+评审是人事核心流程，涉及自动提醒+公示发文"
  - cap_id: "CAP-005"; name: "干部导师管理"; type: "supporting"; commands: ["CMD-019","CMD-020","CMD-021"]; events: ["EVT-019","EVT-020","EVT-021"]; reasoning: "支撑人才发展，导师结对+书库维护"
  - cap_id: "CAP-006"; name: "人事档案管理"; type: "supporting"; commands: ["CMD-027","CMD-028"]; events: ["EVT-027","EVT-028"]; reasoning: "档案转入归档线上化"
  - cap_id: "CAP-007"; name: "信息安全管理"; type: "supporting"; commands: ["CMD-029","CMD-030"]; events: ["EVT-029","EVT-030"]; reasoning: "按敏感等级分级审批+权限自动管控"
  - cap_id: "CAP-008"; name: "人事大屏"; type: "supporting"; commands: ["CMD-032"]; events: ["EVT-032"]; reasoning: "数据可视化看板，支撑管理决策"
  - cap_id: "CAP-009"; name: "假期提醒"; type: "general"; commands: ["CMD-031"]; events: ["EVT-031"]; reasoning: "通用通知能力，可复用"

  actors:
  - actor_id: "ACT-001"; name: "员工（试用期）"; type: "business"; data_scope: "本人考核数据、本人待办"; menu_permissions: ["试用期考核任务书","试用期考核"]; responsibilities: ["确认任务书","填写工作小结","查看个人考核记录"]
  - actor_id: "ACT-002"; name: "师傅（指导人）"; type: "business"; data_scope: "本人所带徒弟数据"; menu_permissions: ["试用期考核任务书","试用期考核"]; responsibilities: ["编辑任务书","评分","考核结果填写"]
  - actor_id: "ACT-003"; name: "科长"; type: "approval"; data_scope: "本部门人员数据"; menu_permissions: ["试用期考核任务书","试用期考核","职称初定"]; responsibilities: ["审核任务书","审核考核","审核职称初定"]
  - actor_id: "ACT-004"; name: "部门经理"; type: "approval"; data_scope: "本部门所有人事数据"; menu_permissions: ["试用期考核","高级技术岗位任务书","高级技术岗位考核","职称初定","职称评审"]; responsibilities: ["审核考核","审核任务书","打分","可修改考核"]
  - actor_id: "ACT-005"; name: "人资（HR）"; type: "business"; data_scope: "全公司人事数据"; menu_permissions: ["全部"]; responsibilities: ["发起考核","归档","查看导师库","维护书库","发起职称初定","发起职称评审"]
  - actor_id: "ACT-006"; name: "组织规划管理员"; type: "business"; data_scope: "技术岗位聘任数据"; menu_permissions: ["技术岗位集中聘任"]; responsibilities: ["发起中初级/破格晋升聘任"]
  - actor_id: "ACT-007"; name: "培训工程师"; type: "business"; data_scope: "本部门培训数据"; menu_permissions: ["技术岗位集中聘任"]; responsibilities: ["组织评审会","审核聘任流程","打分"]
  - actor_id: "ACT-008"; name: "部门规划员"; type: "business"; data_scope: "本部门聘任数据"; menu_permissions: ["技术岗位集中聘任"]; responsibilities: ["发起运行序列技术岗位聘任"]
  - actor_id: "ACT-009"; name: "分管领导"; type: "approval"; data_scope: "分管部门人事数据"; menu_permissions: ["高级技术岗位任务书"]; responsibilities: ["审批高级技术岗位任务书"]
  - actor_id: "ACT-010"; name: "高评委"; type: "approval"; data_scope: "破格/越级晋升数据"; menu_permissions: ["技术岗位集中聘任"]; responsibilities: ["审议破格/越级晋升申请"]
  - actor_id: "ACT-011"; name: "党委会"; type: "approval"; data_scope: "破格/越级晋升数据"; menu_permissions: ["技术岗位集中聘任"]; responsibilities: ["最终审批破格/越级晋升"]
  - actor_id: "ACT-012"; name: "正式员工"; type: "business"; data_scope: "本人数据"; menu_permissions: ["高级技术岗位任务书","职称评审","人事档案转入归档","人力资源信息使用申请"]; responsibilities: ["发起任务书","申报职称评审","发起档案申请","发起信息使用申请"]

  # ═══════════════════════════════════════════
  # Channel B：结构化需求提取
  # ═══════════════════════════════════════════
  structured_requirements:
    functions:
    - id: "FUNC-001"; name: "试用期考核任务书签订"; description: "培训系统同步数据→师傅编辑任务书(基础素质+专业素质+占比)→徒弟确认→科长审核"; actors: ["ACT-002","ACT-001","ACT-003","ACT-005"]; priority: "P0"; related_events: ["EVT-001","EVT-002","EVT-003","EVT-004"]
    - id: "FUNC-002"; name: "试用期考核"; description: "人资批量发起→徒弟填写四个模块→师傅评分+考核结果→科长审核→部门经理审核→人资归档"; actors: ["ACT-005","ACT-001","ACT-002","ACT-003","ACT-004"]; priority: "P0"; related_events: ["EVT-005","EVT-006","EVT-007","EVT-008","EVT-009"]
    - id: "FUNC-003"; name: "技术岗位集中聘任"; description: "支持5种晋升类型(中初级/绩优/破格/高级/运行序列)，含筛选逻辑、评审会组织、多级审批"; actors: ["ACT-006","ACT-007","ACT-008","ACT-003","ACT-004","ACT-005","ACT-010","ACT-011"]; priority: "P0"; related_events: ["EVT-010","EVT-011","EVT-012","EVT-013","EVT-014"]
    - id: "FUNC-004"; name: "高级技术岗位任务书签订"; description: "员工发起关键业绩承诺书→人资审核→部门经理审核→分管领导审批"; actors: ["ACT-012","ACT-005","ACT-004","ACT-009"]; priority: "P0"; related_events: ["EVT-015","EVT-016"]
    - id: "FUNC-005"; name: "高级技术岗位考核"; description: "任务书通过后自动生成考核→员工录入述职述廉→部门经理打分→人资归档(支持退回)"; actors: ["ACT-005","ACT-012","ACT-004"]; priority: "P0"; related_events: ["EVT-017","EVT-018"]
    - id: "FUNC-006"; name: "干部导师库管理"; description: "人资查看/维护导师信息+徒弟结对(每名导师最多3名)+赠书记录+状态跟踪"; actors: ["ACT-005"]; priority: "P1"; related_events: ["EVT-019","EVT-020"]
    - id: "FUNC-007"; name: "干部导师书库维护"; description: "人资维护书籍信息+库存自动计算+赠送记录"; actors: ["ACT-005"]; priority: "P1"; related_events: ["EVT-020","EVT-021"]
    - id: "FUNC-008"; name: "职称初定"; description: "提前15天自动提醒→人资发起筛选名单→员工填写→逐级审核→归档"; actors: ["ACT-005","ACT-001","ACT-003","ACT-004"]; priority: "P0"; related_events: ["EVT-022","EVT-023","EVT-024"]
    - id: "FUNC-009"; name: "职称评审"; description: "员工申报(含多子表)→人资审核→部门经理审核→组长评审→主任评审→人资部门经理审核→公示发文"; actors: ["ACT-012","ACT-005","ACT-004"]; priority: "P0"; related_events: ["EVT-025","EVT-026"]
    - id: "FUNC-010"; name: "人事档案转入归档申请"; description: "支持本人发起/组织新增/转入材料三种类型，含代发起场景"; actors: ["ACT-012","ACT-004","ACT-005"]; priority: "P1"; related_events: ["EVT-027","EVT-028"]
    - id: "FUNC-011"; name: "人力资源信息使用申请"; description: "按高/低敏感等级分级审批，审批通过自动授权+有效期+操作日志"; actors: ["ACT-012","ACT-003","ACT-004","ACT-005"]; priority: "P1"; related_events: ["EVT-029","EVT-030"]
    - id: "FUNC-012"; name: "假期提醒"; description: "中台数据同步→按规则定时触发(5/8/11月初)→钉钉/邮件提醒员工年假/探亲假余额"; actors: ["ACT-001"]; priority: "P2"; related_events: ["EVT-031"]
    - id: "FUNC-013"; name: "人员指标大屏-干部数据"; description: "SAP同步干部基础数据→自动统计年龄分布→大屏展示(中层/基层平均年龄、40岁以下比例)"; actors: ["ACT-005","ACT-004","ACT-009"]; priority: "P2"; related_events: ["EVT-032"]
    - id: "FUNC-014"; name: "人员指标大屏-入职数据"; description: "校招趋势/性别学历分布/TOP10高校/招聘完成率/渠道分布等可视化"; actors: ["ACT-005","ACT-004","ACT-009"]; priority: "P2"; related_events: ["EVT-032"]
    - id: "FUNC-015"; name: "人员指标大屏-离职数据"; description: "离职趋势/部门职级分布/年限分布/原因类型分析等可视化"; actors: ["ACT-005","ACT-004","ACT-009"]; priority: "P2"; related_events: ["EVT-032"]

    entities:
    - id: "ENT-001"; name: "试用期考核任务书"; parent_entity: null; fields_hint: ["姓名","所在部/科","合同期限","员工号","入职时间","试用期结束时间","入职途径","拟聘岗位名称","学历"]
    - id: "ENT-002"; name: "考核指标(基础素质)"; parent_entity: "ENT-001"; fields_hint: ["考核项","考核项说明","占比","详情评分","评分办法","备注"]
    - id: "ENT-003"; name: "考核指标(专业素质)"; parent_entity: "ENT-001"; fields_hint: ["考核项","考核项说明","占比","详情评分","评分办法","评分"]
    - id: "ENT-004"; name: "试用期考核"; parent_entity: null; fields_hint: ["试用期间培训完成情况","工作任务以及完成情况","不足以及改进建议","其他","考核结果","整体评价"]
    - id: "ENT-005"; name: "技术岗位聘任"; parent_entity: null; fields_hint: ["晋升类型","发起人员","所属部门","发起日期"]
    - id: "ENT-006"; name: "聘任员工信息"; parent_entity: "ENT-005"; fields_hint: ["姓名","员工工号","所在部门","职级","资格级别","当前职级工作时间","技术授权书附件","近三年绩效","评审分数"]
    - id: "ENT-007"; name: "评审会信息"; parent_entity: "ENT-005"; fields_hint: ["参评人员","评审时间","评审结果"]
    - id: "ENT-008"; name: "高级技术岗位任务书"; parent_entity: null; fields_hint: ["员工号","姓名","部门","岗位名称","发起日期","审批状态"]
    - id: "ENT-009"; name: "关键业绩承诺书"; parent_entity: "ENT-008"; fields_hint: ["考核维度","内容","目标值","来源"]
    - id: "ENT-010"; name: "高级技术岗位考核"; parent_entity: null; fields_hint: ["基本情况","思想政治表现","主要业绩情况","人才培养情况","廉洁从业情况","存在的不足和改进措施","下一步工作设想"]
    - id: "ENT-011"; name: "干部导师"; parent_entity: null; fields_hint: ["工号","姓名","最高学历","职务类别","职务层级","职务名称","职务起始时间","参加工作时间","职称","管理干部层级"]
    - id: "ENT-012"; name: "徒弟信息"; parent_entity: "ENT-011"; fields_hint: ["徒弟姓名","工号","结对开始时间","赠书的书籍名称","状态跟踪"]
    - id: "ENT-013"; name: "导师书库"; parent_entity: null; fields_hint: ["书籍名称","书籍类别","总数量","已赠送数量","剩余数量"]
    - id: "ENT-014"; name: "赠书记录"; parent_entity: "ENT-013"; fields_hint: ["导师姓名","赠送时间","赠送对象"]
    - id: "ENT-015"; name: "职称初定"; parent_entity: null; fields_hint: ["姓名","出生日期","民族","政治面貌","最高学历","学校","专业","学制","学位","相片","外语程度","主要学习经历"]
    - id: "ENT-016"; name: "职称评审申报"; parent_entity: null; fields_hint: ["姓名","现名","曾用名","性别","民族","出生日期","现任专业技术职务","参加工作时间","最高学历"]
    - id: "ENT-017"; name: "学习培训经历"; parent_entity: "ENT-016"; fields_hint: ["起止时间","专业或主要内容","学习地点","证明人"]
    - id: "ENT-018"; name: "工作经历"; parent_entity: "ENT-016"; fields_hint: ["起止时间","单位","从事何专业技术工作","职务"]
    - id: "ENT-019"; name: "业绩登记"; parent_entity: "ENT-016"; fields_hint: ["起止时间","专业技术工作名称","工作内容","本人起何作用","完成情况及效果"]
    - id: "ENT-020"; name: "著作论文"; parent_entity: "ENT-016"; fields_hint: ["日期","名称及内容提要","出版/登载/获奖情况","合(独)著/译"]
    - id: "ENT-021"; name: "考试成绩"; parent_entity: "ENT-016"; fields_hint: ["日期","考试种类","考试科目","考试成绩","组织考试单位"]
    - id: "ENT-022"; name: "人事档案转入归档"; parent_entity: null; fields_hint: ["员工号","姓名","部门","申请类型","档案来源","档案材料份数","申请日期","归档日期"]
    - id: "ENT-023"; name: "人力资源信息使用申请"; parent_entity: null; fields_hint: ["申请人姓名","申请人工号","所在部门","申请日期","是否涉密信息","数据敏感等级","审批状态","查看权限有效期"]
    - id: "ENT-024"; name: "假期提醒"; parent_entity: null; is_dictionary: false; fields_hint: ["假期余额","提醒时间","通知方式"]

    business_rules:
    - id: "RULE-001"; rule: "技术岗位聘任必须严格遵循公司人事管理制度"; rule_type: "flow"; implementability: "state_machine"; scope: "技术岗位聘任"
    - id: "RULE-002"; rule: "系统对接培训系统、考勤系统、SAP、UE系统"; rule_type: "data"; implementability: "submit_validation"; scope: "全部"
    - id: "RULE-003"; rule: "操作全程留痕可审计"; rule_type: "data"; implementability: "submit_validation"; scope: "全部"
    - id: "RULE-004"; rule: "适配公司现有统一身份认证体系"; rule_type: "permission"; implementability: "submit_validation"; scope: "全部"
    - id: "RULE-005"; rule: "所有占比之和必须等于100%"; rule_type: "data"; implementability: "submit_validation"; scope: "试用期考核任务书"
    - id: "RULE-006"; rule: "每名导师最多带三名徒弟"; rule_type: "data"; implementability: "submit_validation"; scope: "干部导师库"
    - id: "RULE-007"; rule: "提前15天自动提醒干部人事管理员触发职称初定"; rule_type: "flow"; implementability: "state_machine"; scope: "职称初定"
    - id: "RULE-008"; rule: "中初级晋升:职级8以下+满2年+资格级别中级及以上"; rule_type: "flow"; implementability: "state_machine"; scope: "技术岗位聘任A"
    - id: "RULE-009"; rule: "绩优晋升:职级8以下+资格级别中级及以上+上年度绩效A+年限18个月"; rule_type: "flow"; implementability: "state_machine"; scope: "技术岗位聘任B"
    - id: "RULE-010"; rule: "破格越级晋升:职级8以下+资格级别中级及以上+绩效条件+年限12个月"; rule_type: "flow"; implementability: "state_machine"; scope: "技术岗位聘任C"
    - id: "RULE-011"; rule: "高级晋升:近三年绩效至少一个B+职级8及以上满3年+高级职称"; rule_type: "flow"; implementability: "state_machine"; scope: "技术岗位聘任D"
    - id: "RULE-012"; rule: "后台筛选范围可以放大(如满20个月展示)，让用户自己选择"; rule_type: "data"; implementability: "frontend_filter"; scope: "技术岗位聘任"
    - id: "RULE-013"; rule: "授权确定后可跳过评审会，直接到部门经理"; rule_type: "flow"; implementability: "state_machine"; scope: "技术岗位聘任"
    - id: "RULE-014"; rule: "信息使用申请审批通过后自动授予查看权限，默认有效期7个工作日"; rule_type: "permission"; implementability: "submit_validation"; scope: "人力资源信息使用申请"
    - id: "RULE-015"; rule: "5月/8月/11月初第一天提醒员工剩余年假"; rule_type: "flow"; implementability: "state_machine"; scope: "假期提醒"
    - id: "RULE-016"; rule: "高敏感数据(身份证/银行卡/薪资等)须经业务科长+业务经理+人资科长+人资经理四级审批"; rule_type: "permission"; implementability: "state_machine"; scope: "人力资源信息使用申请"
    - id: "RULE-017"; rule: "低敏感数据(工号/部门/岗位等)经业务科长+人资科长两级审批"; rule_type: "permission"; implementability: "state_machine"; scope: "人力资源信息使用申请"

    integrations:
    - system: "培训系统"; direction: "inbound"; purpose: "试用期师徒协议数据同步"; protocol_hint: "实时/定时"
    - system: "HR系统"; direction: "inbound"; purpose: "干部基础数据同步(大屏)"; protocol_hint: "定时"
    - system: "考勤系统"; direction: "inbound"; purpose: "考勤数据同步至数据中台"; protocol_hint: "定时"
    - system: "SAP系统"; direction: "inbound"; purpose: "员工基础数据同步/大屏数据来源"; protocol_hint: "定时"
    - system: "UE系统"; direction: "inbound"; purpose: "员工基础数据同步"; protocol_hint: "定时"
    - system: "数据中台"; direction: "inbound"; purpose: "统一数据汇聚平台(考勤/SAP/UE)"; protocol_hint: "定时"
    - system: "钉钉"; direction: "outbound"; purpose: "假期提醒通知"; protocol_hint: "推送"
    - system: "邮件系统"; direction: "outbound"; purpose: "假期提醒通知"; protocol_hint: "SMTP"

    constraints:
    - type: "business"; description: "系统流程与功能必须严格遵循公司人事管理制度"; is_original: true
    - type: "business"; description: "技术岗位聘任管理办法"; is_original: true
    - type: "technical"; description: "支持并发用户数≥200，页面响应时间≤3秒"; is_original: true
    - type: "technical"; description: "支持Chrome/Edge/Firefox主流浏览器最新3个版本"; is_original: true
    - type: "regulatory"; description: "系统数据必须符合公司数据安全管理规范"; is_original: true

  pain_points:
  - pain_id: "PAIN-001"; description: "技术岗位聘任流程效率低下(纸质申请反复修改、传递慢、授权周期长)"; severity: "high"; affected_capabilities: ["CAP-002"]
  - pain_id: "PAIN-002"; description: "试用期考核缺乏系统化管理(纸质协议易丢失、考核指标不规范、无法与培训系统联动)"; severity: "high"; affected_capabilities: ["CAP-001"]
  - pain_id: "PAIN-003"; description: "人事档案和信息使用管理不规范(纸质流程、缺乏电子化审批、数据敏感等级无明确定义)"; severity: "high"; affected_capabilities: ["CAP-006","CAP-007"]
  - pain_id: "PAIN-004"; description: "干部导师管理缺失(结对无系统记录、赠书记录分散、缺乏管控)"; severity: "medium"; affected_capabilities: ["CAP-005"]

  open_questions:
  - q_id: "Q-001"; question: "待确认：组织评审会是否必须？(原文标注'待确定')"; category: "ambiguous"; affected_events: ["EVT-011"]; potential_impact: "medium"
  - q_id: "Q-002"; question: "权限管理规则(自动授权+有效期+操作日志)需要评估是否可以实现"; category: "missing_info"; affected_functions: ["FUNC-011"]; potential_impact: "high"
  - q_id: "Q-003"; question: "假期提醒模板待后续提供"; category: "missing_info"; affected_functions: ["FUNC-012"]; potential_impact: "low"
  - q_id: "Q-004"; question: "高级技术岗位考核中的评价说明模板蓝色备注展示方式需确认"; category: "ambiguous"; affected_functions: ["FUNC-005"]; potential_impact: "low"

  coverage:
    all_functions_extracted: true
    all_events_identified: true
    all_workflows_captured: true
    all_business_rules_extracted: true
    all_fields_extracted: true
    source_anchor_coverage_pct: 90
    bidirectional_binding_complete: true
    remaining_uncertainties: 4
```
