-- 椒江农商行数智中心-督导中心 DDL
-- 生成日期: 2026-06-01 | 引擎: design-workflow V2.2

-- 9标准字段: data_id, create_member, create_time, create_member_ip_address,
--   last_mod_member, last_mod_time, last_mod_member_ip_address, del_flag, source_system

CREATE TABLE t_supervision_task (
    data_id VARCHAR(64) PRIMARY KEY COMMENT '主键',
    task_name VARCHAR(256) NOT NULL COMMENT '任务名称',
    task_type VARCHAR(32) NOT NULL COMMENT '自动/手动',
    supervision_type VARCHAR(32) COMMENT '日常督办/专项督办',
    task_status VARCHAR(32) NOT NULL DEFAULT '进行中' COMMENT '进行中/已完成/已超期',
    responsible_dept VARCHAR(256) COMMENT '负责部门(JSON数组)',
    responsible_person VARCHAR(64) COMMENT '负责人ID',
    start_time DATETIME COMMENT '开始时间',
    end_time DATETIME COMMENT '截止时间',
    template_id VARCHAR(64) COMMENT 'FK→t_task_template',
    rule_template_id VARCHAR(64) COMMENT 'FK→t_rule_template',
    warning_rule_id VARCHAR(64) COMMENT 'FK→t_warning_rule',
    supervision_content TEXT COMMENT '督导信息内容',
    source_task_id VARCHAR(64) COMMENT '来源OA任务ID',
    creator_id VARCHAR(64) NOT NULL,
    create_member VARCHAR(64), create_time DATETIME,
    create_member_ip_address VARCHAR(64),
    last_mod_member VARCHAR(64), last_mod_time DATETIME,
    last_mod_member_ip_address VARCHAR(64),
    del_flag CHAR(1) DEFAULT '0', source_system VARCHAR(64) DEFAULT 'supervision',
    INDEX idx_status (task_status), INDEX idx_creator (creator_id), INDEX idx_deadline (end_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='督导任务';

CREATE TABLE t_extension_request (
    data_id VARCHAR(64) PRIMARY KEY,
    task_id VARCHAR(64) NOT NULL COMMENT 'FK→t_supervision_task',
    original_deadline DATETIME NOT NULL COMMENT '原截止时间(快照)',
    extension_reason TEXT NOT NULL,
    new_deadline DATETIME NOT NULL,
    next_plan TEXT,
    status VARCHAR(32) NOT NULL DEFAULT '已延期审批中',
    reject_reason VARCHAR(512),
    applicant_id VARCHAR(64) NOT NULL,
    approver_id VARCHAR(64),
    create_member VARCHAR(64), create_time DATETIME, create_member_ip_address VARCHAR(64),
    last_mod_member VARCHAR(64), last_mod_time DATETIME, last_mod_member_ip_address VARCHAR(64),
    del_flag CHAR(1) DEFAULT '0', source_system VARCHAR(64) DEFAULT 'supervision',
    INDEX idx_task (task_id), INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='延期申请';

CREATE TABLE t_warning_rule (
    data_id VARCHAR(64) PRIMARY KEY,
    rule_name VARCHAR(128) NOT NULL,
    notify_type VARCHAR(128) NOT NULL COMMENT 'JSON数组',
    is_enabled CHAR(1) DEFAULT '1',
    overdue_days INT NOT NULL,
    remind_person VARCHAR(512) COMMENT 'JSON数组',
    create_member VARCHAR(64), create_time DATETIME, create_member_ip_address VARCHAR(64),
    last_mod_member VARCHAR(64), last_mod_time DATETIME, last_mod_member_ip_address VARCHAR(64),
    del_flag CHAR(1) DEFAULT '0', source_system VARCHAR(64) DEFAULT 'supervision',
    UNIQUE KEY uk_name (rule_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警规则';

CREATE TABLE t_rule_template (
    data_id VARCHAR(64) PRIMARY KEY,
    rule_name VARCHAR(128) NOT NULL,
    deadline_days INT,
    is_enabled CHAR(1) DEFAULT '1',
    source_table VARCHAR(128) NOT NULL,
    create_member VARCHAR(64), create_time DATETIME, create_member_ip_address VARCHAR(64),
    last_mod_member VARCHAR(64), last_mod_time DATETIME, last_mod_member_ip_address VARCHAR(64),
    del_flag CHAR(1) DEFAULT '0', source_system VARCHAR(64) DEFAULT 'supervision',
    UNIQUE KEY uk_name (rule_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='规则模板';

CREATE TABLE t_rule_condition (
    data_id VARCHAR(64) PRIMARY KEY,
    template_id VARCHAR(64) NOT NULL COMMENT 'FK→t_rule_template',
    source_field VARCHAR(128) NOT NULL,
    operator VARCHAR(32) NOT NULL COMMENT '=,≠,>,<,≥,≤,包含,不包含,为空,不为空',
    target_value VARCHAR(256),
    relation VARCHAR(8) DEFAULT 'AND',
    is_enabled CHAR(1) DEFAULT '1',
    remark VARCHAR(200),
    sort_order INT DEFAULT 0,
    create_member VARCHAR(64), create_time DATETIME, create_member_ip_address VARCHAR(64),
    last_mod_member VARCHAR(64), last_mod_time DATETIME, last_mod_member_ip_address VARCHAR(64),
    del_flag CHAR(1) DEFAULT '0', source_system VARCHAR(64) DEFAULT 'supervision',
    INDEX idx_template (template_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='规则条件';

CREATE TABLE t_supervision_comment (
    data_id VARCHAR(64) PRIMARY KEY,
    task_id VARCHAR(64) NOT NULL COMMENT 'FK→t_supervision_task',
    comment_content VARCHAR(200) NOT NULL,
    commenter_id VARCHAR(64) NOT NULL,
    comment_time DATETIME NOT NULL,
    create_member VARCHAR(64), create_time DATETIME, create_member_ip_address VARCHAR(64),
    last_mod_member VARCHAR(64), last_mod_time DATETIME, last_mod_member_ip_address VARCHAR(64),
    del_flag CHAR(1) DEFAULT '0', source_system VARCHAR(64) DEFAULT 'supervision',
    INDEX idx_task (task_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='领导督批';

CREATE TABLE t_task_template (
    data_id VARCHAR(64) PRIMARY KEY,
    template_code VARCHAR(64) NOT NULL,
    template_name VARCHAR(128) NOT NULL,
    template_type VARCHAR(64) NOT NULL,
    status VARCHAR(32) DEFAULT '启用',
    rule_template_id VARCHAR(64),
    notify_type VARCHAR(128),
    supervision_content TEXT,
    score_max INT COMMENT '满分',
    score_rules TEXT COMMENT '评分规则JSON',
    create_member VARCHAR(64), create_time DATETIME, create_member_ip_address VARCHAR(64),
    last_mod_member VARCHAR(64), last_mod_time DATETIME, last_mod_member_ip_address VARCHAR(64),
    del_flag CHAR(1) DEFAULT '0', source_system VARCHAR(64) DEFAULT 'supervision',
    UNIQUE KEY uk_code (template_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='任务模板';
