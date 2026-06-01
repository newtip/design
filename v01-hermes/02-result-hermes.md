# Agent 02 — Industry Insight Result (Hermes)

## 苍南二期人事系统 — Industry Insight

```yaml
industry_insight:
  project_name: "苍南二期人事系统"
  project_archetype: "approval_workflow"
  
  knowledge_base_hits:
  - kb_hit_id: "KB-001"; source: "AE设计常见问题知识库.md"; source_section: "3.1 业务流（流程闭环）"; matched_keywords: ["审批","审核","退回","重新提交"]; summary: "审批类系统必须设计完整的通过/驳回/撤回/重新提交状态闭环，待办中心与业务详情页双入口"; impacts: "本项目有7条以上审批流（任务书/考核/聘任/职称/档案/信息使用），退回机制必须独立事件"; route_to: ["03-ddd-architecture","05-solution-writer"]; confidence: "high"
  - kb_hit_id: "KB-002"; source: "AE设计常见问题知识库.md"; source_section: "5.3 统一待办"; matched_keywords: ["待办","处理","流转"]; summary: "多审批流系统应设计统一待办中心，按角色+状态聚合待办项"; impacts: "人资/科长/部门经理等需在统一待办中看到跨模块任务"; route_to: ["03-ddd-architecture"]; confidence: "high"
  - kb_hit_id: "KB-003"; source: "AE设计常见问题知识库.md"; source_section: "3.7 多租户"; matched_keywords: ["角色","权限","数据范围","部门"]; summary: "人社系统常见组织架构树+数据权限按部门级联隔离"; impacts: "数据范围(本人/本部门/全公司)需要基于组织树实现"; route_to: ["03-ddd-architecture","04-data-model"]; confidence: "high"
  - kb_hit_id: "KB-004"; source: "AE设计常见问题知识库.md"; source_section: "5.4 统一消息"; matched_keywords: ["通知","消息","提醒"]; summary: "统一消息中心封装多渠道（钉钉/邮件/站内信），支持模板化"; impacts: "假期提醒需对接钉钉+邮件，职称初定/评审也有通知需求"; route_to: ["03-ddd-architecture"]; confidence: "medium"
  - kb_hit_id: "KB-005"; source: "AE设计常见问题知识库.md"; source_section: "3.10 库存管理并发"; matched_keywords: ["并发","多人协同","批量"]; summary: "批量操作（如批量发起考核/批量发起聘任）需考虑并发冲突和幂等性"; impacts: "试用期考核批量发起、技术岗位聘任批量选择均涉及并发"; route_to: ["04-data-model"]; confidence: "medium"

  project_archetype_analysis:
    primary_type: "approval_workflow"
    secondary_types: ["multi_role_collaboration","analytics_dashboard","ledger_management"]
    reasoning: "核心业务流程均为审批驱动（考核/聘任/职称/档案/信息使用），涉及11种角色多级审批；附带数据大屏和台账管理"
    evidence: ["FUNC-001","FUNC-002","FUNC-003","FUNC-008","FUNC-009","FUNC-010","FUNC-011"]

  requirement_maturity:
    score: 82
    level: "high"
    assessment_summary: "功能定义完整、角色权限清晰、流程步骤明确、字段列表详尽。少数待确认项(评审会是否必须、权限自动授予可行性)不影响主流程建模。"
    missing_dimensions:
    - dimension: "数据权限边界"; severity: "medium"; description: "数据范围(本人/本部门/全公司)已定义但组织树结构未明确"; impact: "影响数据隔离方案设计"
    - dimension: "异常流程"; severity: "medium"; description: "仅提及退回机制但未定义超时处理、并发冲突策略"; impact: "需在设计阶段补充异常处理"
    high_risk_ambiguities: ["Q-002"]
    enrichment_needed: true

  industry_patterns:
  - pattern_id: "PAT-001"; name: "审批类系统闭环模式"; applicable_when: ["出现审批、驳回、重新提交、待办处理"]; recommended_design_moves: ["通过/驳回/撤回/重新提交形成完整状态闭环","统一待办中心聚合跨模块任务","退回时标注原因并允许修改后重新提交"]; common_failure_modes: ["只设计通过路径遗漏驳回后补正","审批超时无自动处理","多人审批未区分会签/或签"]; route_to: ["03-ddd-architecture","04-data-model"]; confidence: "high"; evidence: ["FUNC-001","FUNC-002","FUNC-003","FUNC-008","FUNC-009"]
  - pattern_id: "PAT-002"; name: "人社系统多级审批模式"; applicable_when: ["多角色、逐级审批、敏感等级分级"]; recommended_design_moves: ["审批链配置化（非硬编码）","按敏感等级动态生成审批链","同级别审批支持会签/或签"]; common_failure_modes: ["审批链硬编码导致变更困难","敏感等级变化后审批链未联动"]; route_to: ["03-ddd-architecture"]; confidence: "high"; evidence: ["FUNC-011","RULE-016","RULE-017"]
  - pattern_id: "PAT-003"; name: "考核评估模式"; applicable_when: ["评分、多维度考核、占比校验"]; recommended_design_moves: ["考核模板+实例分离","占比自动校验(100%)","评分留痕(操作人+时间+IP)"]; common_failure_modes: ["考核维度硬编码","占比校验缺失","评分记录无审计"]; route_to: ["03-ddd-architecture","04-data-model"]; confidence: "high"; evidence: ["FUNC-001","FUNC-002","FUNC-005","RULE-005"]

  industry_recommendations:
  - recommendation_id: "REC-001"; recommendation: "建立统一待办中心，聚合跨模块审批任务，按角色+状态分组"; status: "recommended_not_confirmed"; based_on: "PAT-001+KB-002"; requirement_evidence: ["FUNC-001","FUNC-002","FUNC-003","FUNC-008","FUNC-009","FUNC-010","FUNC-011"]; affected_design_areas: ["architecture","domain_model"]; risk_if_ignored: "用户需在多个模块间切换寻找待办，体验差"; needs_user_confirmation: true; confidence: "high"
  - recommendation_id: "REC-002"; recommendation: "技术岗位聘任5种晋升类型的筛选逻辑应配置化（规则引擎），避免硬编码"; status: "recommended_not_confirmed"; based_on: "PAT-002"; requirement_evidence: ["FUNC-003","RULE-008","RULE-009","RULE-010","RULE-011"]; affected_design_areas: ["domain_model","data_model"]; risk_if_ignored: "晋升条件变更需改代码、重新发布"; needs_user_confirmation: true; confidence: "high"
  - recommendation_id: "REC-003"; recommendation: "数据敏感等级+审批链联动配置化，支持管理员调整"; status: "recommended_not_confirmed"; based_on: "PAT-002"; requirement_evidence: ["FUNC-011","RULE-016","RULE-017"]; affected_design_areas: ["domain_model","data_model"]; risk_if_ignored: "敏感等级调整需要开发介入"; needs_user_confirmation: true; confidence: "high"
  - recommendation_id: "REC-004"; recommendation: "批量操作（考核发起/聘任发起）需加幂等键防重复提交"; status: "assumption_for_review"; based_on: "KB-005"; requirement_evidence: ["FUNC-002","FUNC-003"]; affected_design_areas: ["data_model"]; risk_if_ignored: "批量操作重复提交导致数据不一致"; needs_user_confirmation: false; confidence: "medium"
  - recommendation_id: "REC-005"; recommendation: "统一消息中心封装钉钉/邮件/站内信，模板化管理通知内容"; status: "assumption_for_review"; based_on: "KB-004"; requirement_evidence: ["FUNC-012"]; affected_design_areas: ["architecture"]; risk_if_ignored: "通知渠道变更需改多处代码"; needs_user_confirmation: false; confidence: "medium"

  exception_and_boundary:
    per_flow_analysis:
    - flow_id: "FLOW-001"; flow_name: "试用期考核任务书签订"; current_exception_coverage: "partial"; missing_exceptions: [{exception_id:"EXC-001",exception_type:"timeout",description:"师傅超时未编辑任务书",severity:"medium",recommended_handling:"定时提醒+超时自动提醒人资"}]; boundary_conditions: [{condition:"培训系统数据同步失败",current_status:"missing",recommendation:"重试机制+失败告警+人工触发同步"}]
    - flow_id: "FLOW-002"; flow_name: "试用期考核"; current_exception_coverage: "partial"; missing_exceptions: [{exception_id:"EXC-002",exception_type:"rejection",description:"考核被退回后重新提交",severity:"high",recommended_handling:"退回原因必填+保留修改记录+重新触发审批链"},{exception_id:"EXC-003",exception_type:"concurrency",description:"批量发起时并发冲突",severity:"high",recommended_handling:"乐观锁+幂等键"}]; boundary_conditions: [{condition:"岗位调整/离职等因素导致考核中断",current_status:"covered",recommendation:"已定义（指导人/科长/部门经理可修改）"}]
    - flow_id: "FLOW-003"; flow_name: "技术岗位集中聘任(中初级)"; current_exception_coverage: "partial"; missing_exceptions: [{exception_id:"EXC-004",exception_type:"rejection",description:"聘任被驳回",severity:"high",recommended_handling:"驳回原因+允许重新发起+记录驳回历史"},{exception_id:"EXC-005",exception_type:"data_conflict",description:"年限/绩效数据与SAP不一致",severity:"medium",recommended_handling:"同步校验+差异提示+人工确认"}]; boundary_conditions: [{condition:"评审会是否必须（待确认）",current_status:"partially",recommendation:"默认可选跳过+培训工程师勾选"},{condition:"授权书线上线下同步",current_status:"covered",recommendation:"保留附件上传入口+线上同步"}]
    - flow_id: "FLOW-009"; flow_name: "人力资源信息使用申请"; current_exception_coverage: "full"; missing_exceptions: []; boundary_conditions: [{condition:"有效期届满自动失效",current_status:"covered",recommendation:"定时任务扫描+到期自动回收权限"}]

  design_decision_backlog:
  - decision_id: "DEC-001"; question: "审批链是硬编码还是配置化？"; why_it_matters: "审批角色可能调整（如增加/减少审批级别），影响系统可维护性"; industry_default: "配置化审批链（规则引擎或审批模板表）"; recommended_default: "配置化+审批模板，支持按模块定义审批节点和角色"; alternatives: ["硬编码if-else","工作流引擎(如Activiti/Flowable)"]; affected_agents: ["03-ddd-architecture","04-data-model"]; requires_confirmation: true; confidence: "high"
  - decision_id: "DEC-002"; question: "数据权限隔离方案：基于组织树还是基于角色标签？"; why_it_matters: "涉及'本部门'/'分管部门'等数据范围实现"; industry_default: "组织树+部门级联查询"; recommended_default: "组织树方案（部门→科室层级），支持向上/向下级联"; alternatives: ["RBAC标签","固定部门ID列表"]; affected_agents: ["03-ddd-architecture","04-data-model"]; requires_confirmation: true; confidence: "high"
  - decision_id: "DEC-003"; question: "考核模板（基础素质5项）是内置固定还是可配置？"; why_it_matters: "基础素质指标可能随制度调整变化"; industry_default: "可配置考核模板表"; recommended_default: "内置默认+允许管理员新增/禁用指标"; alternatives: ["完全硬编码","完全自由配置"]; affected_agents: ["03-ddd-architecture","04-data-model"]; requires_confirmation: true; confidence: "medium"

  routing_summary:
    "03-ddd-architecture":
      patterns: ["PAT-001","PAT-002","PAT-003"]
      recommendations: ["REC-001","REC-002","REC-003","REC-005"]
      decisions: ["DEC-001","DEC-002","DEC-003"]
      exceptions: ["EXC-001","EXC-002","EXC-003","EXC-004","EXC-005"]
    "04-data-model":
      patterns: ["PAT-001","PAT-003"]
      recommendations: ["REC-002","REC-003","REC-004"]
      decisions: ["DEC-001","DEC-002","DEC-003"]
      knowledge_base_hits: ["KB-003","KB-005"]
    "05-solution-writer":
      recommendations: ["REC-001","REC-002","REC-003","REC-004","REC-005"]
      decisions: ["DEC-001","DEC-002","DEC-003"]
      exceptions: ["EXC-001","EXC-002","EXC-003","EXC-004","EXC-005"]
```
