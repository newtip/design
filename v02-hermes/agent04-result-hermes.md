# STAGE_4: Data Model Agent — 执行结果

## data_model

### Entity → Table Mapping

| table_name | aggregate | context | entity |
|------------|-----------|---------|--------|
| tc_training_plan | AGG-001 | CTX-001 | TrainingPlan |
| tc_trainee_info | AGG-001 | CTX-001 | TraineeInfo(sub-table) |
| enr_enrollment | AGG-002 | CTX-002 | Enrollment |
| enr_enrollee_info | AGG-002 | CTX-002 | EnrolleeInfo(sub-table) |
| tdm_training_demand | AGG-003 | CTX-003 | TrainingDemand |
| tdm_demand_personnel | AGG-003 | CTX-003 | DemandPersonnel(sub-table) |
| exm_exam_demand | AGG-004 | CTX-005 | ExamDemand |
| exm_exam_arrangement | AGG-005 | CTX-005 | ExamArrangement |
| exm_exam_score | AGG-006 | CTX-006 | ExamScore |
| ojt_on_job_training | — | CTX-004 | OnJobTraining |

### Field Semantics

**tc_training_plan (开班计划)**:
| field | db_type | required | semantic | note |
|-------|---------|----------|----------|------|
| plan_name | VARCHAR(128) | Y | ownership | 班级名称 |
| is_contractor | CHAR(1) | Y | ownership | 是否承包商开班 |
| org_unit | VARCHAR(128) | Y | ownership | 开班单位 |
| training_month | VARCHAR(32) | Y | ownership | 培训月份 |
| course_id | VARCHAR(64) | Y | foreign_reference | → t_course.data_id |
| course_code | VARCHAR(64) | Y | snapshot | 快照(选课时) |
| classroom | VARCHAR(128) | Y | snapshot | 快照(选课时) |
| instructor_id | VARCHAR(64) | Y | foreign_reference | → t_user.data_id |
| instructor_name | VARCHAR(64) | Y | snapshot | 快照(选课时) |
| start_time | DATETIME | Y | ownership | |
| end_time | DATETIME | Y | ownership | |
| capacity | INT | Y | ownership | 培训容量 |
| description | TEXT | N | ownership | 培训简介 |

**Projection Fields (不建列):**
| field | source_entity | join_path | reason |
|-------|--------------|-----------|--------|
| enrolled_count | enr_enrollment | plan_id → tc_training_plan.data_id, status='已通过', COUNT | 报名人数统计 |
| remaining_capacity | (derived) | capacity - enrolled_count | 计算字段 |

### ER Relationships

| from_table | to_table | cardinality | fk | description |
|------------|----------|-------------|-----|-------------|
| tc_trainee_info | tc_training_plan | N:1 | plan_id | 学员归属开班 |
| enr_enrollment | tc_training_plan | N:1 | plan_id | 报名关联开班 |
| enr_enrollee_info | enr_enrollment | N:1 | enrollment_id | 报名人员 |
| tdm_demand_personnel | tdm_training_demand | N:1 | demand_id | 需求人员 |
| exm_exam_demand | tc_training_plan | N:1 | training_plan_id | 考试关联培训 |
| exm_exam_arrangement | exm_exam_demand | N:1 | exam_demand_id | 安排关联需求 |
| exm_exam_score | exm_exam_arrangement | N:1 | arrangement_id | 成绩关联安排 |

### DDL (核心表)

```sql
-- ============================================================
-- 表名: tc_training_plan (开班计划)
-- 聚合: AGG-001 (CTX-001 TrainingPlanContext)
-- 投影字段: enrolled_count(enr_enrollment, JOIN plan_id + COUNT), remaining_capacity(计算)
-- ============================================================
CREATE TABLE tc_training_plan (
  data_id                    VARCHAR(64) NOT NULL COMMENT '主键',
  plan_name                  VARCHAR(128) NOT NULL COMMENT '班级名称',
  is_contractor              CHAR(1) DEFAULT '0' COMMENT '是否承包商开班 0=否 1=是',
  org_unit                   VARCHAR(128) NOT NULL COMMENT '开班单位',
  training_month             VARCHAR(32) NOT NULL COMMENT '培训月份',
  course_id                  VARCHAR(64) DEFAULT NULL COMMENT '关联课程 → t_course.data_id',
  course_code                VARCHAR(64) NOT NULL COMMENT '课程编码(快照)',
  classroom                  VARCHAR(128) NOT NULL COMMENT '培训教室(快照)',
  instructor_id              VARCHAR(64) DEFAULT NULL COMMENT '教员 → t_user.data_id',
  instructor_name            VARCHAR(64) NOT NULL COMMENT '教员姓名(快照)',
  start_time                 DATETIME NOT NULL COMMENT '开始时间',
  end_time                   DATETIME NOT NULL COMMENT '结束时间',
  capacity                   INT NOT NULL COMMENT '培训容量',
  description                TEXT DEFAULT NULL COMMENT '培训简介',
  -- 9标准字段
  create_member              VARCHAR(64) DEFAULT NULL COMMENT '创建人',
  create_time                DATETIME DEFAULT NULL COMMENT '创建时间',
  create_member_ip_address   VARCHAR(64) DEFAULT NULL COMMENT '创建人IP',
  last_mod_member            VARCHAR(64) DEFAULT NULL COMMENT '最后更新人',
  last_mod_time              DATETIME DEFAULT NULL COMMENT '最后更新时间',
  last_mod_member_ip_address VARCHAR(64) DEFAULT NULL COMMENT '最后更新人IP',
  del_flag                   CHAR(1) DEFAULT '0' COMMENT '删除标记',
  source_system              VARCHAR(64) DEFAULT NULL COMMENT '来源系统',
  PRIMARY KEY (data_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='开班计划 | 投影: enrolled_count(enr_enrollment)';

-- ============================================================
-- 表名: enr_enrollment (培训报名)
-- 聚合: AGG-002 (CTX-002 EnrollmentContext)
-- ============================================================
CREATE TABLE enr_enrollment (
  data_id                    VARCHAR(64) NOT NULL COMMENT '主键',
  plan_id                    VARCHAR(64) NOT NULL COMMENT '关联开班 → tc_training_plan.data_id',
  applicant_id               VARCHAR(64) NOT NULL COMMENT '申请人 → t_user.data_id',
  applicant_unit             VARCHAR(128) NOT NULL COMMENT '申请单位',
  enrollment_count           INT NOT NULL COMMENT '本次报名人数',
  status                     VARCHAR(32) NOT NULL DEFAULT '待审核' COMMENT '状态: 待审核/已通过/待重新申请',
  reject_reason              VARCHAR(512) DEFAULT NULL COMMENT '退回原因',
  -- 9标准字段
  create_member              VARCHAR(64) DEFAULT NULL COMMENT '创建人',
  create_time                DATETIME DEFAULT NULL COMMENT '创建时间',
  create_member_ip_address   VARCHAR(64) DEFAULT NULL COMMENT '创建人IP',
  last_mod_member            VARCHAR(64) DEFAULT NULL COMMENT '最后更新人',
  last_mod_time              DATETIME DEFAULT NULL COMMENT '最后更新时间',
  last_mod_member_ip_address VARCHAR(64) DEFAULT NULL COMMENT '最后更新人IP',
  del_flag                   CHAR(1) DEFAULT '0' COMMENT '删除标记',
  source_system              VARCHAR(64) DEFAULT NULL COMMENT '来源系统',
  PRIMARY KEY (data_id),
  KEY idx_plan_id (plan_id),
  KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='培训报名 | 约束: status状态机(待审核→已通过/待重新申请)';

-- ============================================================
-- 表名: exm_exam_demand (考试需求)
-- 聚合: AGG-004 (CTX-005 ExamContext)
-- ============================================================
CREATE TABLE exm_exam_demand (
  data_id                    VARCHAR(64) NOT NULL COMMENT '主键',
  training_plan_id           VARCHAR(64) NOT NULL COMMENT '关联培训 → tc_training_plan.data_id',
  applicant_id               VARCHAR(64) NOT NULL COMMENT '申请人 → t_user.data_id',
  applicant_unit             VARCHAR(128) NOT NULL COMMENT '申请单位',
  status                     VARCHAR(32) NOT NULL DEFAULT '待处理' COMMENT '状态: 待处理/已通过/已退回',
  -- 9标准字段
  create_member              VARCHAR(64) DEFAULT NULL COMMENT '创建人',
  create_time                DATETIME DEFAULT NULL COMMENT '创建时间',
  create_member_ip_address   VARCHAR(64) DEFAULT NULL COMMENT '创建人IP',
  last_mod_member            VARCHAR(64) DEFAULT NULL COMMENT '最后更新人',
  last_mod_time              DATETIME DEFAULT NULL COMMENT '最后更新时间',
  last_mod_member_ip_address VARCHAR(64) DEFAULT NULL COMMENT '最后更新人IP',
  del_flag                   CHAR(1) DEFAULT '0' COMMENT '删除标记',
  source_system              VARCHAR(64) DEFAULT NULL COMMENT '来源系统',
  PRIMARY KEY (data_id),
  KEY idx_training_plan (training_plan_id),
  UNIQUE KEY uk_plan_demand (training_plan_id, del_flag) COMMENT '同一培训不重复发起考试需求'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='考试需求 | 关联: 开班计划(tc_training_plan)';
```

### Constraint Coverage
- total_invariants: 5 (容量校验 + 状态机 + 唯一性 + 数据权限 + 智能填充)
- covered_by_ddl: 1 (唯一性约束)
- covered_by_validation: 4 (容量/状态/权限/填充)
- uncovered: 0

### Projection Field Check
- ✅ 所有 projection_field 未建列（enrolled_count, remaining_capacity）
- ✅ 所有 snapshot_field 标注了快照原因
