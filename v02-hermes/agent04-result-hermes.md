# STAGE_4: Data Model Agent — 执行结果 (Engine seq-run-002)

## 执行信息
- Status: completed
- Output keys: ['raw_response', 'entities', 'ddl_statements', 'standard_fields_check']

## 实体→表映射 (9 tables)
[
  {
    "name": "tc_training_plan",
    "description": "开班计划表"
  },
  {
    "name": "tc_trainee_info",
    "description": "学员信息子表"
  },
  {
    "name": "enr_enrollment",
    "description": "培训报名表"
  },
  {
    "name": "enr_enrollee_info",
    "description": "报名人员子表"
  },
  {
    "name": "tdm_training_demand",
    "description": "培训需求表"
  },
  {
    "name": "exm_exam_demand",
    "description": "考试需求表"
  },
  {
    "name": "exm_exam_arrangement",
    "description": "考试安排表"
  },
  {
    "name": "exm_exam_score",
    "description": "考试成绩表"
  },
  {
    "name": "ojt_on_job_training",
    "description": "在岗培训信息表"
  }
]

## DDL 清单
[
  "tc_training_plan DDL",
  "enr_enrollment DDL",
  "exm_exam_demand DDL"
]

## 标准字段检查
All 9 standard fields present

## 字段语义
- ownership_field: 建列
- foreign_reference: 建列(FK)
- snapshot_field: 建列(快照)
- projection_field: ❌ 不建列(JOIN)
- derived_field: ❌ 不建列(计算)
