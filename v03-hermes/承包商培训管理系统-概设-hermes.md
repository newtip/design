# 承包商培训管理系统 — 概要设计说明书

**版本**: V1.0 | **引擎**: Design Workflow V2.4.1 | **运行**: v03-run

---

# 第1章 功能清单

## 1.1 项目概述
建立统一的承包商培训管理平台...

## 1.2 功能模块总览
| 模块 | 子模块 | 优先级 |
|------|--------|:---:|
| 培训管理 | 开班计划 | P0 |
| 培训管理 | 培训报名 | P0 |
| 培训管理 | 报名审核 | P0 |
| 培训管理 | 培训需求 | P1 |
| 考试管理 | 考试需求 | P0 |
| 考试管理 | 考试安排 | P0 |
| 考试管理 | 成绩录入 | P1 |

## 1.3 角色分析
- 培训部专员: 全部数据, 7项菜单权限
- 承包商接口人: 本单位数据, 5项菜单权限

---

# 第2章 系统架构设计

## 2.1 架构总览
DDD分层架构+事件驱动模式。6个限界上下文,5个核心服务,1个支撑服务。

## 2.2 五层架构
- Interface Layer: Controller/DTO
- Application Layer: ApplicationService/UseCase
- Domain Layer: Entity/Aggregate/Repository
- Infrastructure Layer: RepositoryImpl/MessagePublisher

## 2.3 服务划分
| 服务 | 类型 | Context |
|------|------|---------|
| TrainingPlanService | core | TrainingPlanContext |
| EnrollmentService | core | EnrollmentContext |
| ExamService | core | ExamContext |
| ExamScoreService | core | ExamScoreContext |
| OrganizationService | supporting | OrganizationContext |

---

# 第3章 业务流程设计

## 3.1 核心事件链路
FLOW-001 开班报名审批: 创建开班→报名→审核→通过
FLOW-002 退回重提: 退回→重新提交→再次审核
FLOW-003 考试链路: 发起考试需求→处理→安排→录入成绩

## 3.2 审批状态机
待审核 → 审核 → 已通过 | 已退回 → 待重新申请 → 重新提交 | 结束

---

# 第4章 数据模型设计

## 4.1 实体→表映射
9张数据表,按Context分组。所有表含9标准字段(data_id, create_member, create_time, ... del_flag, source_system)。

## 4.2 E-R关系
TrainingPlan → Enrollment → ExamDemand → ExamArrangement → ExamScore

## 4.3 投影字段
- enrolled_count: JOIN enr_enrollment + COUNT
- remaining_capacity: capacity - enrolled_count (计算字段)

## 4.4 核心DDL
```sql
CREATE TABLE tc_training_plan (
  data_id VARCHAR(64) PRIMARY KEY,
  plan_name VARCHAR(128) NOT NULL,
  capacity INT NOT NULL,
  ...
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

---

# 第5章 功能设计

## 5.1 培训部专员工作台
待办中心: 待审核报名列表 + 待处理培训需求 + 待处理考试需求

## 5.2 开班计划管理
列表页(按角色过滤) + 新增(培训专员/承包商两种表单) + 学员信息子表

## 5.3 培训报名
报名列表→选择开班→填写报名人数+人员子表→提交→审核闭环

## 5.4 考试管理
考试需求发起(筛选已完成培训)→审核→安排考试→录入成绩

---

# 第6章 权限设计

## 6.1 角色权限矩阵
| 功能 | 培训部专员 | 承包商接口人 |
|------|:---:|:---:|
| 开班计划-全部 | ✅ | ❌ |
| 开班计划-本单位 | ✅ | ✅ |
| 报名审核 | ✅ | ❌ |
| 成绩录入 | ✅ | ❌ |

## 6.2 数据隔离
- 培训部专员: WHERE 1=1
- 承包商接口人: WHERE org_unit = current_user.unit

---

# 第7章 非功能设计

## 7.1 性能设计
- 并发用户≥200
- 页面响应≤3秒
- 容量校验用乐观锁

## 7.2 安全设计
- 9标准字段实现操作留痕到IP级别
- 角色数据范围过滤
- API鉴权

## 7.3 可扩展性
- 服务按Context独立部署
- Enrollment→Exam异步事件解耦
- 预留SSO接口

---

# 第8章 遗留问题

| 编号 | 问题 | 状态 |
|:---:|------|:---:|
| Q-001 | 剩余容量计算方式(审核通过 vs 所有报名) | ❓待确认 |
| Q-002 | 月度培训计划数据来源 | ❓待确认 |
| Q-004 | 培训程序录入功能缺失 | ❓待确认 |
| Q-005 | 在岗培训数据来源(外部抓取 vs 手动) | ❓待确认 |
| DEC-001 | 退回时是否释放容量 | 🔶建议释放 |
| DEC-003 | 承包商隔离层级 | ⚠️待客户确认 |

---

# 第9章 工作量评估

| 模块 | 配置 | 开发 | 测试 | 合计 |
|------|:--:|:--:|:--:|:--:|
| 组织用户 | 1 | 2 | 1 | 4 |
| 开班计划 | 1 | 3 | 2 | 6 |
| 报名+审核 | 1 | 4 | 2 | 7 |
| 培训需求 | 1 | 2 | 1 | 4 |
| 考试管理 | 1 | 3 | 2 | 6 |
| 成绩录入 | 0.5 | 2 | 1 | 3.5 |
| 在岗培训 | 0.5 | 2 | 1 | 3.5 |
| 权限+审计 | 1 | 2 | 2 | 5 |
| **小计** | **7** | **20** | **12** | **39** |
| 缓冲(15%) | - | - | - | **6** |
| **总计** | | | | **~45人天** |

---

## 附录A: 事件清单
TrainingPlanCreated→EnrollmentSubmitted→EnrollmentApproved/Rejected→EnrollmentReSubmitted→EnrollmentClosed→TrainingDemandSubmitted→TrainingDemandApproved/Rejected→ExamDemandInitiated→ExamDemandProcessed→ExamArranged→ExamScoreImported→OnJobTrainingRecorded (14 events)

## 附录B: 生成记录
Engine: Design Workflow V2.4.1 | Run: v03-run | Stages: STAGE_0→6 all completed
