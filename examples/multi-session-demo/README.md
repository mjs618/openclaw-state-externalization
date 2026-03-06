# 示例: 跨 3 个 Session 完成 API 项目

> 展示状态外化方案的实际工作流程

---

## 📋 项目背景

**任务**: 为一个电商系统设计 REST API  
**持续时间**: 3 天  
**Session 数**: 3 个  
**关键挑战**: 复杂任务跨天执行，需要保持上下文连贯

---

## 🎬 Session 1: 需求分析与设计

### 启动状态
```
Agent: "读取 manifest.json..."
Agent: "读取 active-task.md..."
Agent: "读取最新 Session 记录..." (无，这是第一次)
Agent: "✅ 项目初始化完成，当前阶段: 需求分析"
```

### 执行工作
1. 与用户讨论 API 需求
2. 设计数据库模型
3. 确定技术栈

### 结束时的状态更新

**manifest.json**:
```json
{
  "current": {
    "activeTask": "api-design",
    "phase": "design",
    "status": "in_progress",
    "lastSession": "2026-03-06-001",
    "totalSessions": 1
  }
}
```

**active-task.md**:
```markdown
## 当前阶段: 设计
- [x] 需求收集
- [x] 数据库设计  
- [ ] API 端点设计 (进行中)
- [ ] 认证方案
```

**sessions/2026-03-06-001.md**:
```markdown
## Session 001: 需求分析

### 完成的工作
- 确定了 3 个核心实体: User, Product, Order
- 选择了技术栈: Node.js + Express + PostgreSQL
- 设计了数据库 schema

### 关键决策
- 使用 JWT 认证
- RESTful 设计风格
- PostgreSQL 主从架构

### 待续工作
- 完成 API 端点设计
- 确定错误处理规范
```

---

## 🎬 Session 2: API 实现

### 启动状态
```
Agent: "读取 manifest.json... 当前 Session: 001"
Agent: "读取 active-task.md... 当前阶段: 设计"
Agent: "读取 sessions/2026-03-06-001.md..."
Agent: "✅ 已恢复上次状态。上次完成: 数据库设计，当前任务: API 端点设计"
```

### 执行工作
1. 完成 API 端点设计
2. 实现 User 模块 CRUD
3. 实现 Product 模块
4. 编写单元测试

### 结束时的状态更新

**manifest.json**:
```json
{
  "current": {
    "activeTask": "api-implementation",
    "phase": "implementation", 
    "status": "in_progress",
    "lastSession": "2026-03-07-002",
    "totalSessions": 2
  }
}
```

**active-task.md**:
```markdown
## 当前阶段: 实现
- [x] API 端点设计
- [x] User 模块 (CRUD + 认证)
- [x] Product 模块
- [ ] Order 模块 (进行中)
- [ ] 集成测试
```

**sessions/2026-03-07-002.md**:
```markdown
## Session 002: API 实现

### 完成的工作
- 设计了 15 个 API 端点
- 实现了 User 模块 (注册/登录/CRUD)
- 实现了 Product 模块
- 编写了 20 个单元测试

### 遇到的问题
- 发现 Product 和 Category 是多对多关系，需要中间表
- 已解决: 创建了 product_category 关联表

### 代码变更
```
新增:
- src/routes/user.js
- src/routes/product.js
- tests/user.test.js

修改:
- src/models/index.js (添加关联)
```

### 待续工作
- 完成 Order 模块
- 添加集成测试
- 性能优化
```

---

## 🎬 Session 3: 测试与交付

### 启动状态
```
Agent: "读取 manifest.json... 当前 Session: 002"
Agent: "读取 active-task.md... 当前阶段: 实现"
Agent: "读取 sessions/2026-03-07-002.md..."
Agent: "✅ 已恢复状态。上次完成: User/Product 模块，当前任务: Order 模块 + 测试"
```

### 执行工作
1. 完成 Order 模块
2. 编写集成测试
3. 性能优化
4. 编写 API 文档

### 项目完成

**manifest.json**:
```json
{
  "current": {
    "activeTask": null,
    "phase": "complete",
    "status": "complete",
    "lastSession": "2026-03-08-003",
    "totalSessions": 3
  },
  "tasks": [
    {
      "id": "api-design",
      "status": "complete"
    },
    {
      "id": "api-implementation", 
      "status": "complete"
    },
    {
      "id": "testing",
      "status": "complete"
    }
  ]
}
```

**active-task.md**:
```markdown
## ✅ 项目已完成

### 成果总结
- 15 个 REST API 端点
- 完整的单元测试 (45 个)
- 集成测试覆盖核心流程
- API 文档 (Swagger)

### 关键指标
- 代码覆盖率: 87%
- 平均响应时间: 45ms
- 零已知 Bug
```

---

## 📊 效果对比

### 传统方式 (无状态外化)

| 天数 | 时间消耗 | 问题 |
|------|----------|------|
| Day 1 | 2h | 正常进行 |
| Day 2 | 3h | 花 1h 重新理解昨天的工作 |
| Day 3 | 3h | 花 1h 重新理解前两天的内容 |
| **总计** | **8h** | 2h 浪费在上下文恢复 |

### 状态外化方式

| 天数 | 时间消耗 | 说明 |
|------|----------|------|
| Day 1 | 2h | 正常进行，记录状态 |
| Day 2 | 2h | 5分钟恢复上下文，直接继续 |
| Day 3 | 2h | 5分钟恢复上下文，直接继续 |
| **总计** | **6h** | 节省 2h，效率提升 25% |

---

## 💡 关键收获

1. **上下文恢复**: 从 1h → 5min，节省 90% 时间
2. **决策可追溯**: 所有技术决策记录在 decisions/ 目录
3. **问题可复盘**: 遇到的坑和解决方案都在 Session 记录里
4. **知识沉淀**: findings.md 积累 reusable 的知识

---

## 🚀 试试这个示例

```bash
# 1. 初始化示例项目
./templates/state-externalization/init-state.sh "电商 API 项目" "设计并实现电商系统 REST API"

# 2. 模拟 Day 1 Session
# 手动更新 state/sessions/2026-03-06-001.md (复制上面的内容)

# 3. 模拟 Day 2 Session
# 启动新 Session，观察 Agent 如何自动恢复上下文

# 4. 查看完整状态
cat state/manifest.json
cat state/active-task.md
ls state/sessions/
```
