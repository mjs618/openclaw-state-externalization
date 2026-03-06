# 长期复杂任务状态外化方案 v2.0

> 基于 OpenClaw + planning-with-files 技能的多天协作优化

---

## 核心升级

| 维度 | 基础版 | 升级版 |
|------|--------|--------|
| 文件组织 | 项目根目录平铺 | 结构化目录 (`state/`) |
| 协作支持 | 单人单 Session | 多人多 Session 兼容 |
| 恢复机制 | 手动读取 | 自动 Session 恢复 |
| 任务粒度 | 单个任务 | 任务树（父任务+子任务） |
| 状态持久化 | 文本文件 | JSON + Markdown 双格式 |

---

## 目录结构

```
project/
├── state/                          # 状态外化目录
│   ├── manifest.json               # 全局状态清单（机器可读）
│   ├── README.md                   # 项目概览（人可读）
│   ├── active-task.md              # 当前激活任务
│   ├── task-tree.md                # 任务依赖树
│   ├── decisions/                  # 决策记录
│   │   ├── 001-技术选型.md
│   │   └── 002-架构设计.md
│   ├── sessions/                   # Session 历史
│   │   ├── 2026-03-06-001.md
│   │   └── 2026-03-06-002.md
│   └── context/                    # 上下文快照
│       ├── codebase-summary.md
│       └── external-refs.md
├── task_plan.md                    # 当前任务计划
├── findings.md                     # 研究发现
└── progress.md                     # 进度日志
```

---

## 关键文件详解

### 1. manifest.json - 全局状态
```json
{
  "version": "2.0",
  "project": {
    "name": "项目名称",
    "description": "一句话描述",
    "createdAt": "2026-03-06T00:00:00Z",
    "updatedAt": "2026-03-06T14:00:00Z"
  },
  "current": {
    "activeTask": "task-001",
    "phase": "implementation",
    "status": "in_progress",
    "lastSession": "2026-03-06-002",
    "totalSessions": 5
  },
  "tasks": [
    {
      "id": "task-001",
      "name": "核心功能开发",
      "status": "in_progress",
      "parent": null,
      "children": ["task-002", "task-003"],
      "owner": "agent:main",
      "startedAt": "2026-03-06T10:00:00Z"
    }
  ]
}
```

### 2. README.md - 项目概览
- **项目目标**（一句话）
- **当前状态**（进度条+关键指标）
- **快速导航**（链接到各文档）
- **上次更新**（时间+内容摘要）

### 3. active-task.md - 当前任务
- 任务目标
- 当前阶段
- 待办清单（可勾选）
- 阻塞项
- 下一步行动

### 4. sessions/*.md - Session 历史
每个 Session 一个文件，记录：
- Session ID / 时间
- 参与者（如果是协作）
- 完成的工作
- 遇到的问题
- 关键决策
- 下次启动的待办

---

## Session 启动流程

```
1. 读取 state/manifest.json
   → 确定当前激活任务
2. 读取 state/active-task.md
   → 了解当前进度
3. 读取 state/README.md
   → 确认项目上下文
4. 读取最近 Session 记录
   → 了解上次状态
5. 输出 "状态摘要" 给用户
6. 开始执行任务
```

---

## Session 结束流程

```
1. 更新 task_plan.md 进度
2. 写入 findings.md（新发现）
3. 追加 progress.md 日志
4. 创建/更新 sessions/*.md
5. 更新 manifest.json 状态
6. 更新 active-task.md
7. 提交 git commit（可选）
```

---

## 快速启动命令

```bash
# 初始化项目状态结构
openclaw run init-project-state

# 启动新 Session（自动恢复状态）
openclaw run session-start

# 结束当前 Session（保存状态）
openclaw run session-end

# 查看项目状态摘要
openclaw run status-summary
```

---

## 自动化 Hooks

在 `.openclaw/hooks/` 配置：

```yaml
# session-start.yaml
on: session_start
tasks:
  - read: state/manifest.json
  - read: state/active-task.md
  - run: generate-status-summary

# session-end.yaml  
on: session_end
tasks:
  - run: update-manifest
  - run: archive-session
  - run: git-commit-auto
```

---

## 多人协作模式

当多个 Agent/人参与时：

1. **任务分配** - 在 manifest.json 中标记 owner
2. **状态同步** - 通过 git 同步 state/ 目录
3. **冲突处理** - 使用 timestamp-based 合并
4. **交接记录** - 在 sessions/ 中记录交接内容

---

## 下一步

1. **创建模板** - 我帮你生成完整的模板文件
2. **配置自动化** - 设置 Session 启动/结束的自动行为
3. **测试验证** - 用一个实际任务测试完整流程

需要我现在就帮你**初始化**这个结构吗？或者你有具体的长期任务想要用这个方案管理？
