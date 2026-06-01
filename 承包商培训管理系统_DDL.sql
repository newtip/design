-- 承包商培训管理系统 DDL
-- 生成日期: 2026-05-30
-- 数据库: MySQL 8.0

-- ========== 课程基础数据 (CTX-05) ==========
CREATE TABLE course (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(64) NOT NULL COMMENT '课程编码',
    course_number VARCHAR(64) COMMENT '课程编号',
    course_name VARCHAR(256) NOT NULL COMMENT '课程名称',
    org_unit VARCHAR(128) COMMENT '所属部门',
    category VARCHAR(64) COMMENT '所属目录',
    activity_level VARCHAR(32) COMMENT '活动层级',
    open_scope VARCHAR(128) COMMENT '开放范围',
    course_type VARCHAR(32) COMMENT '课程类型',
    assessment_method VARCHAR(32) COMMENT '考核方式',
    training_method VARCHAR(32) COMMENT '培训方式',
    hours DECIMAL(5,1) COMMENT '课时(h)',
    keywords VARCHAR(256) COMMENT '关键字',
    start_time DATETIME COMMENT '课程开始时间',
    end_time DATETIME COMMENT '课程结束时间',
    equivalent_course VARCHAR(256) COMMENT '等效课程',
    prerequisite VARCHAR(256) COMMENT '预修课程',
    instructor VARCHAR(64) COMMENT '教员',
    development_position VARCHAR(128) COMMENT '发展岗位',
    course_owner VARCHAR(64) COMMENT '课程负责人',
    training_target VARCHAR(256) COMMENT '培训对象',
    capacity INT COMMENT '容量',
    is_certified TINYINT(1) DEFAULT 0 COMMENT '是否认证培训课程',
    is_external TINYINT(1) DEFAULT 0 COMMENT '是否外部课程',
    is_party_course TINYINT(1) DEFAULT 0 COMMENT '是否党课',
    is_retraining TINYINT(1) DEFAULT 0 COMMENT '是否复训',
    is_authorized_type TINYINT(1) DEFAULT 0 COMMENT '是否为授权类型',
    satisfaction VARCHAR(32) COMMENT '课程满意度',
    recent_sessions INT COMMENT '近5年开课期次',
    prerequisites_desc TEXT COMMENT '学员先决条件',
    training_objective TEXT COMMENT '培训目标',
    course_content TEXT COMMENT '课程内容',
    training_material TEXT COMMENT '培训教材',
    reference_material TEXT COMMENT '培训参考资料',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_code (course_code),
    KEY idx_name (course_name),
    KEY idx_org (org_unit)
) COMMENT '课程科目台账';

CREATE TABLE course_instructor (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_id BIGINT NOT NULL,
    name VARCHAR(64) NOT NULL,
    employee_id VARCHAR(64) NOT NULL,
    org_unit VARCHAR(128),
    instructor_type VARCHAR(32),
    FOREIGN KEY (course_id) REFERENCES course(id)
) COMMENT '授权教员子表';

CREATE TABLE course_attachment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    course_id BIGINT NOT NULL,
    attachment_name VARCHAR(256) NOT NULL,
    category VARCHAR(64),
    FOREIGN KEY (course_id) REFERENCES course(id)
) COMMENT '课程附件子表';

-- ========== 培训班 (CTX-01, AGG-01) ==========
CREATE TABLE training_class (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(128) NOT NULL,
    is_contractor_class TINYINT(1) DEFAULT 0,
    org_unit VARCHAR(128) NOT NULL,
    training_month VARCHAR(7),
    course_id BIGINT NOT NULL,
    classroom VARCHAR(128),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    description TEXT,
    capacity INT NOT NULL,
    creator_id VARCHAR(64) NOT NULL,
    creator_role VARCHAR(32) NOT NULL,
    status VARCHAR(32) DEFAULT 'open',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY idx_course (course_id),
    KEY idx_creator (creator_id),
    KEY idx_status (status)
) COMMENT '开班计划';

CREATE TABLE training_class_trainee (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    training_class_id BIGINT NOT NULL,
    name VARCHAR(64) NOT NULL,
    company VARCHAR(128) NOT NULL,
    employee_id VARCHAR(64) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (training_class_id) REFERENCES training_class(id)
) COMMENT '培训班学员子表';

-- ========== 报名 (CTX-01, AGG-02) ==========
CREATE TABLE registration (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    training_class_id BIGINT NOT NULL,
    applicant_id VARCHAR(64) NOT NULL,
    applicant_unit VARCHAR(128) NOT NULL,
    enroll_count INT NOT NULL,
    remaining_capacity INT NOT NULL COMMENT '快照字段',
    status VARCHAR(32) DEFAULT 'pending',
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    reviewed_at DATETIME,
    reviewer_id VARCHAR(64),
    KEY idx_class (training_class_id),
    KEY idx_applicant (applicant_id),
    KEY idx_status (status),
    FOREIGN KEY (training_class_id) REFERENCES training_class(id)
) COMMENT '培训报名';

CREATE TABLE registrant (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    registration_id BIGINT NOT NULL,
    name VARCHAR(64) NOT NULL,
    company VARCHAR(128) NOT NULL,
    employee_id VARCHAR(64) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (registration_id) REFERENCES registration(id)
) COMMENT '报名人员子表';

-- ========== 培训需求 (CTX-02, AGG-03) ==========
CREATE TABLE training_demand (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    applicant_id VARCHAR(64) NOT NULL,
    applicant_unit VARCHAR(128) NOT NULL,
    course_id BIGINT NOT NULL,
    expected_start_time VARCHAR(64),
    trainee_count INT NOT NULL,
    status VARCHAR(32) DEFAULT 'pending',
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    reviewed_at DATETIME,
    reviewer_id VARCHAR(64),
    KEY idx_applicant (applicant_id),
    KEY idx_status (status)
) COMMENT '培训需求';

CREATE TABLE training_demand_trainee (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    demand_id BIGINT NOT NULL,
    name VARCHAR(64) NOT NULL,
    company VARCHAR(128) NOT NULL,
    employee_id VARCHAR(64) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    FOREIGN KEY (demand_id) REFERENCES training_demand(id)
) COMMENT '培训需求人员子表';

-- ========== 考试 (CTX-03, AGG-04/05/06) ==========
CREATE TABLE exam_request (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    applicant_unit VARCHAR(128) NOT NULL,
    training_proof_attachment VARCHAR(512),
    exam_name VARCHAR(128) NOT NULL,
    status VARCHAR(32) DEFAULT 'pending',
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    reviewed_at DATETIME,
    reviewer_id VARCHAR(64),
    KEY idx_status (status)
) COMMENT '考试需求';

CREATE TABLE exam_candidate (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    exam_request_id BIGINT NOT NULL,
    name VARCHAR(64) NOT NULL,
    employee_id VARCHAR(64),
    id_card VARCHAR(18),
    phone VARCHAR(20),
    zhixueyun_account VARCHAR(64),
    exam_subject VARCHAR(128),
    training_proof_submitted TINYINT(1) DEFAULT 0,
    FOREIGN KEY (exam_request_id) REFERENCES exam_request(id)
) COMMENT '考试人员子表';

CREATE TABLE exam_schedule (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    exam_name VARCHAR(128) NOT NULL,
    exam_location VARCHAR(128),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    candidate_count INT NOT NULL,
    creator_id VARCHAR(64) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    KEY idx_creator (creator_id)
) COMMENT '考试安排';

CREATE TABLE scheduled_candidate (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    exam_schedule_id BIGINT NOT NULL,
    contractor_unit VARCHAR(128),
    name VARCHAR(64) NOT NULL,
    employee_id VARCHAR(64),
    phone VARCHAR(20),
    id_card VARCHAR(18),
    zhixueyun_account VARCHAR(64),
    exam_subject VARCHAR(128),
    FOREIGN KEY (exam_schedule_id) REFERENCES exam_schedule(id)
) COMMENT '已安排考试人员';

CREATE TABLE exam_score (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    exam_schedule_id BIGINT NOT NULL,
    contractor_unit VARCHAR(128),
    contractor_liaison VARCHAR(64),
    exam_name VARCHAR(128),
    start_time DATETIME,
    end_time DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (exam_schedule_id) REFERENCES exam_schedule(id)
) COMMENT '考试成绩';

CREATE TABLE exam_score_detail (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    exam_score_id BIGINT NOT NULL,
    person_name VARCHAR(64) NOT NULL,
    score VARCHAR(32),
    FOREIGN KEY (exam_score_id) REFERENCES exam_score(id)
) COMMENT '成绩明细';

-- ========== 在岗培训 (CTX-04, AGG-07) ==========
CREATE TABLE onjob_training (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    contractor VARCHAR(128) NOT NULL,
    course_name VARCHAR(128),
    instructor VARCHAR(64),
    class_teacher VARCHAR(64),
    start_time DATETIME,
    end_time DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT '在岗培训信息';

CREATE TABLE onjob_training_trainee (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ojt_id BIGINT NOT NULL,
    name VARCHAR(64) NOT NULL,
    employee_id VARCHAR(64) NOT NULL,
    score VARCHAR(32),
    FOREIGN KEY (ojt_id) REFERENCES onjob_training(id)
) COMMENT '在岗培训人员子表';
