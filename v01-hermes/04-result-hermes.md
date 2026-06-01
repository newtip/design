# Agent 04 — Data Model Result (Hermes)

## 苍南二期人事系统 — DDL

```sql
-- ============================================================
-- 苍南二期人事系统 — 数据模型 DDL
-- Context: CTX-001 ProbationContext
-- ============================================================

-- 试用期考核任务书
-- 聚合: AGG-001 TaskBook (CTX-001)
CREATE TABLE pb_task_book (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    employee_name              VARCHAR(128) DEFAULT NULL COMMENT '姓名',
    department                 VARCHAR(128) DEFAULT NULL COMMENT '所在部/科',
    contract_period            VARCHAR(64)  DEFAULT NULL COMMENT '合同期限',
    employee_no                VARCHAR(64)  DEFAULT NULL COMMENT '员工号',
    entry_date                 DATETIME     DEFAULT NULL COMMENT '入职时间',
    probation_end_date         DATETIME     DEFAULT NULL COMMENT '试用期结束时间',
    entry_path                 VARCHAR(64)  DEFAULT NULL COMMENT '入职途径',
    proposed_position          VARCHAR(128) DEFAULT NULL COMMENT '拟聘岗位名称',
    education                  VARCHAR(64)  DEFAULT NULL COMMENT '学历',
    status                     VARCHAR(32)  DEFAULT NULL COMMENT '状态: draft→pending_confirm→pending_approve→approved',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    UNIQUE KEY uk_employee_no (employee_no, del_flag) COMMENT 'INV-001: 员工号唯一',
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试用期考核任务书 | 子表: pb_basic_quality_indicator, pb_professional_quality_indicator';

-- 基础素质指标子表
CREATE TABLE pb_basic_quality_indicator (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    task_book_id               VARCHAR(64)  NOT NULL COMMENT '关联 pb_task_book.data_id',
    indicator_name             VARCHAR(64)  DEFAULT NULL COMMENT '考核项(责任心/主动性/团队意识/学习领悟/沟通协调)',
    indicator_desc             VARCHAR(256) DEFAULT NULL COMMENT '考核项说明',
    ratio                      DECIMAL(5,2) DEFAULT NULL COMMENT '占比(%)',
    detail_score               TEXT         DEFAULT NULL COMMENT '详情评分',
    scoring_method             VARCHAR(64)  DEFAULT NULL COMMENT '评分办法',
    score                      DECIMAL(5,2) DEFAULT NULL COMMENT '评分',
    remark                     VARCHAR(512) DEFAULT NULL COMMENT '备注',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_task_book (task_book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='基础素质指标 | 约束: 占比之和=100%通过应用层校验';

-- 专业素质指标子表
CREATE TABLE pb_professional_quality_indicator (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    task_book_id               VARCHAR(64)  NOT NULL COMMENT '关联 pb_task_book.data_id',
    indicator_name             VARCHAR(128) DEFAULT NULL COMMENT '考核项',
    indicator_desc             VARCHAR(256) DEFAULT NULL COMMENT '考核项说明',
    ratio                      DECIMAL(5,2) DEFAULT NULL COMMENT '占比(%)',
    detail_score               TEXT         DEFAULT NULL COMMENT '详情评分',
    scoring_method             VARCHAR(64)  DEFAULT NULL COMMENT '评分办法',
    score                      DECIMAL(5,2) DEFAULT NULL COMMENT '评分',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_task_book (task_book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='专业素质指标(师傅自定义) | 约束: 所有占比之和=100%';

-- ============================================================
-- 试用期考核
-- 聚合: AGG-002 ProbationAssessment (CTX-001)
-- ============================================================
CREATE TABLE pb_probation_assessment (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    task_book_id               VARCHAR(64)  NOT NULL COMMENT '关联 pb_task_book.data_id',
    employee_name              VARCHAR(128) DEFAULT NULL COMMENT '姓名',
    department                 VARCHAR(128) DEFAULT NULL COMMENT '所在部/科',
    contract_period            VARCHAR(64)  DEFAULT NULL COMMENT '合同期限',
    employee_no                VARCHAR(64)  DEFAULT NULL COMMENT '员工号',
    entry_date                 DATETIME     DEFAULT NULL COMMENT '入职时间',
    probation_end_date         DATETIME     DEFAULT NULL COMMENT '试用期结束时间',
    entry_path                 VARCHAR(64)  DEFAULT NULL COMMENT '入职途径',
    proposed_position          VARCHAR(128) DEFAULT NULL COMMENT '拟聘岗位名称',
    mentor_name                VARCHAR(128) DEFAULT NULL COMMENT '指导人',
    mentor_position            VARCHAR(128) DEFAULT NULL COMMENT '指导人岗位名称',
    mentor_rank                VARCHAR(64)  DEFAULT NULL COMMENT '指导人岗位职级',
    -- 四个模块（富文本）
    training_completion        TEXT         DEFAULT NULL COMMENT '试用期间培训完成情况',
    task_completion            TEXT         DEFAULT NULL COMMENT '工作任务以及完成情况',
    shortcomings               TEXT         DEFAULT NULL COMMENT '不足以及改进建议',
    others                     TEXT         DEFAULT NULL COMMENT '其他',
    assessment_result          VARCHAR(32)  DEFAULT NULL COMMENT '考核结果: 合格/不合格',
    overall_evaluation         TEXT         DEFAULT NULL COMMENT '对试用员工整体评价',
    status                     VARCHAR(32)  DEFAULT NULL COMMENT '状态: launched→filled→scored→reviewed→archived',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_task_book (task_book_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='试用期考核 | 投影: 师傅姓名/岗位/职级通过JOIN获取';

-- ============================================================
-- Context: CTX-002 AppointmentContext
-- ============================================================

-- 技术岗位聘任
-- 聚合: AGG-003 PositionAppointment (CTX-002)
CREATE TABLE ap_position_appointment (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    promotion_type             VARCHAR(64)  NOT NULL COMMENT '晋升类型: A中初级/B绩优/C破格越级/D高级/E运行序列',
    initiator                  VARCHAR(128) DEFAULT NULL COMMENT '发起人员',
    department                 VARCHAR(128) DEFAULT NULL COMMENT '所属部门',
    initiate_date              DATETIME     DEFAULT NULL COMMENT '发起日期',
    status                     VARCHAR(32)  DEFAULT NULL COMMENT '状态: initiated→tech_reviewed→meeting→scored→dept_approved→hr_approved→completed',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_status (status),
    KEY idx_promotion_type (promotion_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='技术岗位集中聘任 | 子表: ap_appointment_employee, ap_review_meeting';

-- 聘任员工子表
CREATE TABLE ap_appointment_employee (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    appointment_id             VARCHAR(64)  NOT NULL COMMENT '关联 ap_position_appointment.data_id',
    employee_name              VARCHAR(128) DEFAULT NULL COMMENT '姓名',
    employee_no                VARCHAR(64)  DEFAULT NULL COMMENT '员工工号',
    department                 VARCHAR(128) DEFAULT NULL COMMENT '所在部门',
    rank                       INT          DEFAULT NULL COMMENT '职级',
    qualification_level        VARCHAR(64)  DEFAULT NULL COMMENT '资格级别',
    current_rank_tenure        INT          DEFAULT NULL COMMENT '当前职级工作时间(月)',
    authorization_attachment   VARCHAR(512) DEFAULT NULL COMMENT '技术授权书附件路径',
    recent_performance         VARCHAR(512) DEFAULT NULL COMMENT '近三年绩效(JSON)',
    proposed_rank              INT          DEFAULT NULL COMMENT '拟聘职级',
    proposed_position          VARCHAR(128) DEFAULT NULL COMMENT '拟聘岗位',
    review_score               DECIMAL(5,2) DEFAULT NULL COMMENT '评审分数',
    skip_review_meeting        CHAR(1)      DEFAULT '0' COMMENT '是否跳过评审会',
    result                     VARCHAR(64)  DEFAULT NULL COMMENT '聘任结果',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_appointment (appointment_id),
    KEY idx_employee_no (employee_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='聘任员工信息 | 投影: 部门全路径通过组织服务获取';

-- 评审会信息子表
CREATE TABLE ap_review_meeting (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    appointment_id             VARCHAR(64)  NOT NULL COMMENT '关联 ap_position_appointment.data_id',
    reviewers                  VARCHAR(1024) DEFAULT NULL COMMENT '评审员列表(JSON)',
    review_time                DATETIME     DEFAULT NULL COMMENT '参评时间',
    review_result              TEXT         DEFAULT NULL COMMENT '评审结果(文本)',
    review_attachment          VARCHAR(512) DEFAULT NULL COMMENT '评审附件',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_appointment (appointment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评审会信息';

-- 高级技术岗位任务书
-- 聚合: AGG-004 SeniorTaskBook (CTX-002)
CREATE TABLE ap_senior_task_book (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    employee_no                VARCHAR(64)  DEFAULT NULL COMMENT '员工号',
    employee_name              VARCHAR(128) DEFAULT NULL COMMENT '姓名',
    department                 VARCHAR(128) DEFAULT NULL COMMENT '部门',
    position_name              VARCHAR(128) DEFAULT NULL COMMENT '岗位名称',
    initiate_date              DATETIME     DEFAULT NULL COMMENT '发起日期',
    approval_status            VARCHAR(32)  DEFAULT NULL COMMENT '审批状态',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_employee_no (employee_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='高级技术岗位任务书 | 子表: ap_performance_commitment';

-- 关键业绩承诺书
CREATE TABLE ap_performance_commitment (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    task_book_id               VARCHAR(64)  NOT NULL COMMENT '关联 ap_senior_task_book.data_id',
    dimension                  VARCHAR(64)  DEFAULT NULL COMMENT '考核维度: 关键业绩承诺/人才培养',
    content                    VARCHAR(512) DEFAULT NULL COMMENT '内容(关键指标/职责/任务)',
    target                     VARCHAR(256) DEFAULT NULL COMMENT '目标值(SMART)',
    source                     VARCHAR(128) DEFAULT NULL COMMENT '来源',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_task_book (task_book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='关键业绩承诺书';

-- 高级技术岗位考核
-- 聚合: AGG-005 SeniorAssessment (CTX-002)
CREATE TABLE ap_senior_assessment (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    task_book_id               VARCHAR(64)  NOT NULL COMMENT '关联 ap_senior_task_book.data_id',
    employee_no                VARCHAR(64)  DEFAULT NULL COMMENT '员工号',
    employee_name              VARCHAR(128) DEFAULT NULL COMMENT '姓名',
    department                 VARCHAR(128) DEFAULT NULL COMMENT '部门',
    position_name              VARCHAR(128) DEFAULT NULL COMMENT '岗位名称',
    initiate_date              DATETIME     DEFAULT NULL COMMENT '发起日期',
    approval_status            VARCHAR(32)  DEFAULT NULL COMMENT '审批状态',
    -- 述职述廉7模块
    basic_info                 TEXT         DEFAULT NULL COMMENT '基本情况',
    ideology                   TEXT         DEFAULT NULL COMMENT '思想政治表现',
    performance                TEXT         DEFAULT NULL COMMENT '主要业绩情况',
    talent_dev                 TEXT         DEFAULT NULL COMMENT '人才培养情况',
    integrity                  TEXT         DEFAULT NULL COMMENT '廉洁从业情况',
    shortcomings               TEXT         DEFAULT NULL COMMENT '存在的不足和改进措施',
    next_plan                  TEXT         DEFAULT NULL COMMENT '下一步工作设想',
    score                      DECIMAL(5,2) DEFAULT NULL COMMENT '部门经理打分',
    status                     VARCHAR(32)  DEFAULT NULL COMMENT '状态: generated→filled→scored→archived',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_task_book (task_book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='高级技术岗位考核 | 投影: 考核人岗位名称/姓名/职级通过组织服务获取';

-- ============================================================
-- Context: CTX-004 MentorContext
-- ============================================================

-- 干部导师
-- 聚合: AGG-008 Mentor (CTX-004)
CREATE TABLE mt_mentor (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    employee_no                VARCHAR(64)  DEFAULT NULL COMMENT '工号',
    employee_name              VARCHAR(128) DEFAULT NULL COMMENT '姓名',
    highest_degree             VARCHAR(64)  DEFAULT NULL COMMENT '最高学历',
    position_category          VARCHAR(64)  DEFAULT NULL COMMENT '职务类别',
    position_level             VARCHAR(64)  DEFAULT NULL COMMENT '职务层级',
    position_name              VARCHAR(128) DEFAULT NULL COMMENT '职务名称',
    position_start_date        DATETIME     DEFAULT NULL COMMENT '职务起始时间',
    work_start_date            DATETIME     DEFAULT NULL COMMENT '参加工作时间',
    title                      VARCHAR(64)  DEFAULT NULL COMMENT '职称',
    manager_level              VARCHAR(64)  DEFAULT NULL COMMENT '管理干部层级',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    UNIQUE KEY uk_employee_no (employee_no, del_flag) COMMENT 'INV-008: 导师唯一'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='干部导师 | 子表: mt_mentee';

-- 徒弟信息
CREATE TABLE mt_mentee (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    mentor_id                  VARCHAR(64)  NOT NULL COMMENT '关联 mt_mentor.data_id',
    mentee_name                VARCHAR(128) DEFAULT NULL COMMENT '徒弟姓名',
    mentee_no                  VARCHAR(64)  DEFAULT NULL COMMENT '工号',
    pairing_start_date         DATETIME     DEFAULT NULL COMMENT '结对开始时间',
    gifted_book                VARCHAR(256) DEFAULT NULL COMMENT '赠书的书籍名称',
    status                     VARCHAR(32)  DEFAULT NULL COMMENT '状态跟踪: 辅导中/期满',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    KEY idx_mentor (mentor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='徒弟信息 | 约束: 每名导师最多3名徒弟(应用层校验)';

-- ============================================================
-- Context: CTX-006 SecurityContext
-- ============================================================

-- 人力资源信息使用申请
-- 聚合: AGG-011 InfoAccessRequest (CTX-006)
CREATE TABLE sc_info_access_request (
    data_id                    VARCHAR(64)  NOT NULL COMMENT '主键',
    applicant_name             VARCHAR(128) DEFAULT NULL COMMENT '申请人姓名',
    applicant_no               VARCHAR(64)  DEFAULT NULL COMMENT '申请人工号',
    department                 VARCHAR(128) DEFAULT NULL COMMENT '所在部门',
    application_date           DATETIME     DEFAULT NULL COMMENT '申请日期',
    is_sensitive               CHAR(1)      DEFAULT '0' COMMENT '是否涉密信息(0=否/1=是)',
    sensitivity_level          VARCHAR(32)  DEFAULT NULL COMMENT '数据敏感等级: high/low',
    usage_description          TEXT         DEFAULT NULL COMMENT '信息使用需求描述',
    usage_purpose              VARCHAR(256) DEFAULT NULL COMMENT '信息使用用途/方式',
    approval_status            VARCHAR(32)  DEFAULT NULL COMMENT '审批状态',
    access_validity_days       INT          DEFAULT 7 COMMENT '查看权限有效期(天),默认7',
    access_expire_time         DATETIME     DEFAULT NULL COMMENT '权限到期时间',
    access_log                 TEXT         DEFAULT NULL COMMENT '操作日志(JSON)',
    idempotent_key             VARCHAR(128) DEFAULT NULL COMMENT '幂等键(防重复提交)',
    create_member              VARCHAR(64)  DEFAULT NULL COMMENT '创建人',
    create_time                DATETIME     DEFAULT NULL COMMENT '创建时间',
    create_member_ip_address   VARCHAR(64)  DEFAULT NULL COMMENT '创建人IP地址',
    last_mod_member            VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人',
    last_mod_time              DATETIME     DEFAULT NULL COMMENT '最后更新时间',
    last_mod_member_ip_address VARCHAR(64)  DEFAULT NULL COMMENT '最后更新人IP地址',
    del_flag                   CHAR(1)      DEFAULT '0' COMMENT '删除标记',
    source_system              VARCHAR(64)  DEFAULT NULL COMMENT '来源系统',
    PRIMARY KEY (data_id),
    UNIQUE KEY uk_idempotent (idempotent_key) COMMENT '幂等键唯一',
    KEY idx_applicant (applicant_no),
    KEY idx_status (approval_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='人力资源信息使用申请 | 约束: INV-013/014/015 审批链按敏感等级自动确定';

-- ============================================================
-- ER 关系汇总
-- ============================================================
-- pb_task_book 1:N pb_basic_quality_indicator (task_book_id)
-- pb_task_book 1:N pb_professional_quality_indicator (task_book_id)
-- pb_task_book 1:1 pb_probation_assessment (task_book_id)
-- ap_position_appointment 1:N ap_appointment_employee (appointment_id)
-- ap_position_appointment 1:N ap_review_meeting (appointment_id)
-- ap_senior_task_book 1:N ap_performance_commitment (task_book_id)
-- ap_senior_task_book 1:1 ap_senior_assessment (task_book_id)
-- mt_mentor 1:N mt_mentee (mentor_id)

-- ============================================================
-- 投影字段清单（不建列，通过JOIN获取）
-- ============================================================
-- pb_probation_assessment.mentor_name → 通过 mentor_id JOIN 组织服务
-- ap_appointment_employee.department_path → 通过 department_id JOIN 组织树
-- ap_senior_assessment.assessor_name → 通过 assessor_id JOIN 组织服务
-- 所有审批记录字段 → 通过审批服务事件溯源获取
-- 所有通知内容 → 通过 NotificationContext 异步消费事件生成
```
