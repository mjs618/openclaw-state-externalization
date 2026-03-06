# 示例

## 示例 1: API 开发项目

跨 3 天完成电商系统 API。

### Day 1: 需求分析

**Session 001** 完成：
- 需求收集
- 数据库设计
- 技术选型

**关键决策:**
- 使用 PostgreSQL 而非 MongoDB
- RESTful 设计风格

### Day 2: 核心实现

**Session 002** 完成：
- User 模块 CRUD
- Product 模块
- JWT 认证

**遇到的问题:**
- Product-Category 多对多关系 → 创建中间表解决

### Day 3: 测试交付

**Session 003** 完成：
- Order 模块
- 集成测试
- API 文档

**成果:**
- 15 个 API 端点
- 87% 测试覆盖率

---

## 示例 2: 数据分析项目

跨 5 天完成销售数据分析。

### Session 分布

| Session | 日期 | 工作内容 | 时长 |
|---------|------|---------|------|
| 001 | 03-01 | 数据清洗 | 3h |
| 002 | 03-02 | 探索性分析 | 4h |
| 003 | 03-03 | 可视化设计 | 3h |
| 004 | 03-04 | 报告撰写 | 2h |
| 005 | 03-05 | 汇报准备 | 2h |

### 关键发现

记录在 `findings.md`：
- Q1 销售额同比增长 23%
- 华北区增长最快
- 周末转化率高于工作日

---

## 示例 3: 多人协作项目

2 个 Agent + 1 个人类协作开发 Web 应用。

### 任务分配

```
project/
├── backend/          @agent-a
│   └── state/
├── frontend/         @agent-b
│   └── state/
└── docs/             @human
    └── state/
```

### 协作流程

1. **每日同步**: 早上 pull，晚上 push
2. **任务边界**: 通过 `task-tree.md` 明确
3. **冲突处理**: manifest 手动合并

---

## 完整项目结构示例

```
my-api-project/
├── state/
│   ├── manifest.json           # 全局状态
│   ├── README.md               # 项目概览
│   ├── active-task.md          # 当前任务
│   ├── task-tree.md            # 任务树
│   ├── decisions/
│   │   ├── 001-database.md     # 数据库选型
│   │   └── 002-auth.md         # 认证方案
│   ├── sessions/
│   │   ├── 2026-03-01-001.md   # Day 1
│   │   ├── 2026-03-02-002.md   # Day 2
│   │   └── 2026-03-03-003.md   # Day 3
│   └── context/
│       └── tech-stack.md       # 技术栈说明
├── src/                        # 源代码
├── tests/                      # 测试
├── task_plan.md                # 任务计划
├── findings.md                 # 研究发现
├── progress.md                 # 进度日志
└── README.md                   # 项目 README
```

---

## 效果对比

### 使用前

| 天数 | 时间 | 说明 |
|------|------|------|
| Day 1 | 2h | 正常工作 |
| Day 2 | 3h | 1h 恢复上下文 |
| Day 3 | 3h | 1h 恢复上下文 |
| **总计** | **8h** | 浪费 2h |

### 使用后

| 天数 | 时间 | 说明 |
|------|------|------|
| Day 1 | 2h | 工作 + 记录状态 |
| Day 2 | 2h | 5min 恢复 + 工作 |
| Day 3 | 2h | 5min 恢复 + 工作 |
| **总计** | **6h** | **节省 2h** |

**效率提升: 25%**
