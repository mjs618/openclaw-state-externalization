# 常见问题 (FAQ)

## 🔧 使用问题

### Q1: 初始化后怎么开始第一个 Session？

**A**: 初始化完成后，Agent 会自动读取状态文件。你只需要说：

> "开始工作" 或 "继续任务"

Agent 会:
1. 读取 `state/manifest.json` 了解全局状态
2. 读取 `state/active-task.md` 获取当前任务
3. 输出状态摘要给你
4. 开始执行

---

### Q2: Session 结束后需要手动做什么？

**A**: 什么都不需要！Agent 会自动：
- 更新 `task_plan.md` 标记完成项
- 追加 `findings.md` 记录新发现
- 追加 `progress.md` 记录 Session 日志
- 创建新的 `sessions/YYYY-MM-DD-XXX.md` 文件
- 更新 `state/manifest.json` 状态

你只需要在对话结束时正常说 "再见" 或 "结束 Session" 即可。

---

### Q3: 如何在多台机器/多个 OpenClaw 实例间同步状态？

**A**: 使用 git 同步：

```bash
# 在每个 Session 结束时
git add state/
git commit -m "Session 003: 完成 API 设计"
git push

# 在新机器上
git clone your-repo
cd your-repo
# 启动 Agent，它会自动读取状态
```

---

### Q4: 状态文件冲突了怎么办？

**A**: 多人协作时可能出现 git 冲突。解决方案：

**冲突类型 1**: `manifest.json` 冲突
```bash
# 手动合并，保留最新的状态
# 或使用工具: npm install -g json-diff
```

**冲突类型 2**: Markdown 文件冲突
```bash
# 手动编辑，保留双方的修改
# 通常不是关键冲突，可以简单合并
```

**建议**: 避免多人同时修改同一个任务。可以分工：
- Agent A 负责任务 1
- Agent B 负责任务 2
- 通过 `state/task-tree.md` 协调

---

### Q5: 可以删除旧的 Session 记录吗？

**A**: 可以，但不建议。Session 记录是项目历史的重要组成部分。

如果确实需要清理：
```bash
# 归档旧 Session
mkdir -p state/sessions/archive
mv state/sessions/2026-03-* state/sessions/archive/

# 更新 manifest.json 中的引用
```

---

### Q6: 如何处理非常长的任务（数月）？

**A**: 使用任务树拆分：

```
project/
├── 阶段1-需求分析/
│   └── state/
├── 阶段2-设计/
│   └── state/
├── 阶段3-实现/
│   └── state/
└── 阶段4-测试/
    └── state/
```

每个阶段有自己的状态目录，完成后归档。

---

## 🐛 故障排查

### Q7: Agent 没有读取状态文件？

**A**: 检查以下几点：

1. **文件路径**: 确保在正确的项目目录启动
2. **文件存在**: `ls state/manifest.json`
3. **Agent 配置**: 确认 Agent 有 `Read` 工具权限
4. **协议触发**: 告诉 Agent "请先读取项目状态"

---

### Q8: manifest.json 格式错误？

**A**: 使用 JSON 验证：

```bash
# 验证 JSON 格式
node -e "JSON.parse(require('fs').readFileSync('state/manifest.json'))" && echo "Valid JSON"

# 或使用 jq
jq . state/manifest.json > /dev/null && echo "Valid JSON"
```

常见错误：
- 缺少逗号
- 使用了单引号而不是双引号
- 尾随逗号（JSON 标准不允许）

---

### Q9: Session 记录没有自动创建？

**A**: 检查初始化脚本权限：

```bash
# 确保脚本可执行
chmod +x templates/state-externalization/init-state.sh

# 手动创建 Session 目录
mkdir -p state/sessions
```

---

## 💡 进阶问题

### Q10: 可以自定义状态结构吗？

**A**: 可以！`manifest.json` 是灵活的，你可以添加自定义字段：

```json
{
  "custom": {
    "priority": "high",
    "deadline": "2026-03-15",
    "stakeholders": ["user1", "user2"]
  }
}
```

只要在 Agent 协议中说明如何读取这些字段即可。

---

### Q11: 如何集成到 CI/CD？

**A**: 示例 GitHub Actions：

```yaml
name: State Validation
on: [push]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate manifest.json
        run: jq . state/manifest.json
      - name: Check for orphaned sessions
        run: |
          last_session=$(jq -r '.current.lastSession' state/manifest.json)
          if [ ! -f "state/sessions/${last_session}.md" ]; then
            echo "Error: Referenced session not found"
            exit 1
          fi
```

---

### Q12: 支持哪些 OpenClaw 版本？

**A**: 已在以下版本测试：
- ✅ OpenClaw 2026.2.x
- ✅ OpenClaw 2026.3.x

如果使用旧版本，可能需要调整模板语法。

---

## 🤝 协作问题

### Q13: 人类和 Agent 如何协作？

**A**: 最佳实践：

1. **Agent 负责**: 执行具体任务，更新技术细节
2. **人类负责**: 审查关键决策，确认方向
3. **沟通方式**: 
   - Agent 在 `state/active-task.md` 的 "待确认事项" 列出需要人类决策的问题
   - 人类回复确认后，Agent 继续执行

---

### Q14: 多个 Agent 怎么避免冲突？

**A**: 策略：

1. **任务分配**: 在 `state/task-tree.md` 明确标注 owner
2. **文件锁定**: 一个 Agent 工作时，在 `active-task.md` 标记 "正在处理中"
3. **频繁同步**: 每个小阶段完成后就 `git commit && git push`

---

## 还有其他问题？

欢迎提交 [Issue](https://github.com/mjs618/openclaw-state-externalization/issues)！
