# 状态外化协议

> 本项目使用 OpenClaw 状态外化方案管理长期复杂任务

---

## 🔔 Session 启动必做

```
1. READ: state/manifest.json
2. READ: state/README.md  
3. READ: state/active-task.md
4. READ: state/sessions/YYYY-MM-DD-XXX.md (最新的)
5. 输出状态摘要给用户
```

---

## 📝 Session 结束必做

```
1. UPDATE: task_plan.md (标记完成项)
2. APPEND: findings.md (新发现)
3. APPEND: progress.md (本次日志)
4. CREATE: state/sessions/YYYY-MM-DD-NNN.md (本次记录)
5. UPDATE: state/active-task.md (更新进度)
6. UPDATE: state/manifest.json (更新状态)
7. UPDATE: state/README.md (更新概览)
```

---

## 📁 关键文件速查

| 文件 | 用途 | 何时更新 |
|------|------|---------|
| `state/manifest.json` | 机器可读的全局状态 | 每次状态变化 |
| `state/README.md` | 人可读的项目概览 | 重大里程碑 |
| `state/active-task.md` | 当前激活任务 | 每天多次 |
| `state/task-tree.md` | 所有任务依赖关系 | 任务变化时 |
| `state/sessions/*.md` | Session 历史记录 | 每个 Session |
| `task_plan.md` | 任务计划 | 阶段完成时 |
| `findings.md` | 研究发现 | 有新发现时 |
| `progress.md` | 进度日志 | 持续更新 |

---

## 🎯 状态标记规范

- `ready` - 准备就绪，等待开始
- `in_progress` - 进行中
- `blocked` - 阻塞，需要解决障碍
- `review` - 待审核/待确认
- `complete` - 已完成
- `archived` - 已归档

---

## ⚡ 快速命令

```bash
# 初始化新项目
./templates/state-externalization/init-state.sh "项目名" "描述"

# 查看当前状态
cat state/manifest.json | jq '.current'

# 列出所有 Session
ls -la state/sessions/
```

---

## 🔗 相关文档

- [完整指南](../state-externalization-guide.md)
- [Planning with Files Skill](../../skills/planning-with-files/SKILL.md)
