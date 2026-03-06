# API 参考

## manifest.json 结构

```json
{
  "version": "2.0",
  "schema": "openclaw-state-manifest",
  "project": {
    "name": "项目名称",
    "description": "项目描述",
    "createdAt": "2026-03-06T00:00:00Z",
    "updatedAt": "2026-03-06T00:00:00Z"
  },
  "current": {
    "activeTask": "task-001",
    "phase": "implementation",
    "status": "in_progress",
    "lastSession": "2026-03-06-001",
    "totalSessions": 5
  },
  "tasks": [
    {
      "id": "task-001",
      "name": "任务名称",
      "status": "in_progress",
      "parent": null,
      "children": ["task-002"],
      "owner": "agent:main",
      "startedAt": "2026-03-06T00:00:00Z"
    }
  ],
  "config": {
    "autoCommit": false,
    "sessionLogging": true,
    "maxSessionHistory": 50
  }
}
```

### 字段说明

| 字段 | 类型 | 说明 |
|------|------|------|
| `version` | string | 状态格式版本 |
| `schema` | string | Schema 标识 |
| `project.name` | string | 项目名称 |
| `project.description` | string | 项目描述 |
| `current.activeTask` | string | 当前激活任务 ID |
| `current.phase` | string | 当前阶段 |
| `current.status` | string | 项目状态 |
| `current.lastSession` | string | 最新 Session ID |
| `current.totalSessions` | number | Session 总数 |
| `tasks` | array | 任务列表 |
| `config.autoCommit` | boolean | 自动提交 |

### 状态枚举

```javascript
// 项目状态
const ProjectStatus = {
  READY: 'ready',           // 准备就绪
  IN_PROGRESS: 'in_progress', // 进行中
  BLOCKED: 'blocked',       // 阻塞
  REVIEW: 'review',         // 审核中
  COMPLETE: 'complete',     // 已完成
  ARCHIVED: 'archived'      // 已归档
};

// 任务状态
const TaskStatus = {
  PENDING: 'pending',       // 待开始
  IN_PROGRESS: 'in_progress', // 进行中
  COMPLETE: 'complete',     // 已完成
  CANCELLED: 'cancelled'    // 已取消
};
```

## Session 文件结构

```markdown
## Session XXX: 标题

### 基本信息
- **Session ID**: XXX
- **开始时间**: YYYY-MM-DD HH:MM
- **结束时间**: YYYY-MM-DD HH:MM
- **关联任务**: task-XXX

### 完成的工作
1. 工作项 1
2. 工作项 2

### 遇到的问题
| 问题 | 解决状态 | 备注 |
|------|----------|------|
| 问题描述 | 已解决 | 解决方案 |

### 关键决策
- **决策 1**: 说明和理由

### 下一步
- [ ] 待办 1
- [ ] 待办 2
```

## 工具脚本 API

### validate.sh

```bash
./scripts/state-tools/validate.sh [state-dir]

# 返回码
# 0: 验证通过
# 1: 验证失败
```

### stats.sh

```bash
./scripts/state-tools/stats.sh [state-dir]

# 输出格式
# 📊 Session 统计报告
# ====================
# 📈 基本统计
# 总 Session 数: 5
# ...
```

### visualize.py

```bash
./scripts/state-tools/visualize.py [options]

Options:
  --dir DIR          项目目录 (默认: .)
  --format FORMAT    输出格式: console, html (默认: console)
  --output FILE      HTML 输出路径 (默认: state-report.html)

# 示例
./scripts/state-tools/visualize.py --format console
./scripts/state-tools/visualize.py --format html --output report.html
```

## 钩子 (Hooks)

### Session 启动钩子

```yaml
# .openclaw/hooks/session-start.yaml
on: session_start
tasks:
  - read: state/manifest.json
  - read: state/active-task.md
  - run: generate-status-summary
```

### Session 结束钩子

```yaml
# .openclaw/hooks/session-end.yaml
on: session_end
tasks:
  - run: update-manifest
  - run: archive-session
  - run: git-commit-auto
```
