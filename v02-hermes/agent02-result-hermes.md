# STAGE_2: Industry Insight Agent — 执行结果

## industry_insight

### 项目类型识别
- project_archetype: approval_workflow（审批流+台账管理混合型）
- primary_type: approval_workflow
- secondary_types: [ledger_management, multi_role_collaboration]
- reasoning: 核心业务链路为开班→报名→审核→考试，典型审批流模式；同时培训记录为台账管理

### 需求成熟度评估
- score: 62
- level: medium
- assessment_summary: 核心功能描述较完整（开班、报名、审核），但存在多处待确认项（剩余容量计算、月度培训计划来源、培训程序录入缺失），异常流程覆盖不足
- missing_dimensions:
  - dimension: 数据权限边界
    severity: high
    description: 未明确承包商接口人的"本单位"数据范围如何界定（组织树层级）
    impact: 影响数据模型中的组织关联设计和权限实现
  - dimension: 异常流程
    severity: high
    description: 需求仅描述了正常审批流通过/退回路径，缺少超时处理、并发报名、容量冲突等异常
    impact: 影响状态机设计和第7章非功能需求
  - dimension: 通知机制
    severity: medium
    description: 未明确审批节点是否需要通知（站内信/邮件/企业微信）
    impact: 影响统一消息设计
  - dimension: 培训程序录入
    severity: high
    description: 1.2.2.2.3 培训程序录入功能描述完全缺失
    impact: 考试管理模块缺少关键功能点
- high_risk_ambiguities: ["Q-001(剩余容量计算)", "Q-005(在岗培训数据来源)", "Q-007(培训程序录入缺失)"]
- enrichment_needed: true

### 行业模式匹配

| pattern_id | name | applicable_when | recommended_design_moves | common_failure_modes |
|------------|------|----------------|------------------------|---------------------|
| PAT-001 | 审批类系统闭环模式 | 出现审批/退回/重新提交/待办处理 | 通过→退回→补正→再次提交形成完整闭环；退回归还容量 | 只设计通过路径，遗漏退回后的补正与容量回收 |
| PAT-002 | 培训管理系统标准模式 | 培训计划→报名→考试→成绩 | 开班与考试建立关联链路(培训→考试需求→安排→成绩)；成绩同步回培训记录 | 开班与考试数据割裂，无法追溯 |
| PAT-003 | 多租户数据隔离模式 | 多承包商共用系统 | 租户级数据隔离(承包商A不可见承包商B数据)；培训部专员跨租户查看 | 数据隔离不彻底导致信息泄露 |
| PAT-004 | 容量管理模式 | 有限资源的报名抢占 | 实时容量校验+乐观锁/悲观锁防超卖；退回时释放容量 | 并发报名时容量超卖 |
| PAT-005 | 智能填充模式 | 选择A自动带出B/C/D | 前端组件联动+后端数据服务获取；带出数据应是快照还是实时引用需决策 | 带出数据与实际数据不一致 |

### 行业增强建议

| rec_id | recommendation | status | risk_if_ignored | needs_user_confirmation |
|--------|---------------|--------|----------------|------------------------|
| REC-001 | 报名退回时自动释放已占用容量 | recommended_not_confirmed | 容量被无效占用，后续报名被拒 | true |
| REC-002 | 开班计划与考试需求建立数据关联 | recommended_not_confirmed | 考试无法追溯到具体培训班级 | false |
| REC-003 | 审批超时自动提醒/升级 | assumption_for_review | 审批无限期挂起 | true |
| REC-004 | 报名容量校验采用乐观锁机制 | recommended_not_confirmed | 并发报名时超卖 | false |
| REC-005 | 增加操作日志(审计留痕) | confirmed_by_requirement | 无法满足数据安全约束 | false |
| REC-006 | 智能填充字段存储为快照 | assumption_for_review | 数据不一致 | true |
| REC-007 | 承包商数据隔离维度确认为"一级单位" | recommended_not_confirmed | 数据权限实现不准确 | true |

### 异常边界补充

| flow_id | current_coverage | missing_exceptions |
|---------|-----------------|-------------------|
| FLOW-001 | partial | EXC-001: 报名时容量已满(拒绝+提示); EXC-002: 审核超时(提醒+升级); EXC-003: 并发报名冲突(乐观锁重试) |
| FLOW-002 | partial | EXC-004: 退回后申请人未在期限内重新提交(自动关闭+释放容量) |
| FLOW-004 | partial | EXC-005: 考试需求引用已删除的开班计划(数据一致性校验) |

### 决策待办

| dec_id | question | recommended_default | affected_agents |
|--------|----------|-------------------|-----------------|
| DEC-001 | 剩余容量=总容量-审核通过人数 or 总容量-所有报名人数 | 建议: 总容量-审核通过人数（防止恶意占位） | 03,04,05 |
| DEC-002 | 智能填充字段(教员/教室)存储为快照还是实时引用 | 建议: 快照(保证历史数据一致性) | 04 |
| DEC-003 | 承包商数据隔离层级: 一级单位 or 完整组织树 | 待客户确认 | 03,04 |
| DEC-004 | 是否需要统一待办中心 | 建议: 是(集中处理报名审核+需求审核+考试需求处理) | 03,05 |

### 路由汇总
- 03-ddd-architecture: patterns=[PAT-001,PAT-002,PAT-003,PAT-004,PAT-005], decisions=[DEC-001,DEC-003,DEC-004]
- 04-data-model: decisions=[DEC-001,DEC-002], knowledge_base_hits=[]
- 05-solution-writer: recommendations=[REC-001,REC-002,REC-003,REC-004,REC-005,REC-006,REC-007], decisions=[DEC-001,DEC-003]
