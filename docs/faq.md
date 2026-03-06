# 常见问题

## 基础问题

### Q: 什么是状态外化？

**A:** 状态外化是将 AI Agent 的工作状态从易失的上下文窗口转移到持久的外部存储的技术。这样即使 Session 结束或重启，状态也不会丢失。

### Q: 适合什么场景？

**A:** 
- 跨多天的复杂任务
- 需要多人/多 Agent 协作的项目
- 需要记录决策过程的项目
- 需要可审计的工作流程

### Q: 需要额外安装什么？

**A:** 
- OpenClaw (核心)
- jq (JSON 处理，可选)
- Python 3.x (可视化工具)
- Git (版本控制)

## 使用问题

### Q: 如何开始第一个 Session？

**A:**
1. 初始化项目结构
2. 告诉 Agent "开始工作"
3. Agent 自动读取状态文件
4. 确认任务目标
5. 开始执行

### Q: Session 结束需要做什么？

**A:** 什么都不需要！Agent 会自动更新所有状态文件。你只需要正常结束对话即可。

### Q: 如何查看项目进度？

**A:**
```bash
# 控制台报告
./scripts/state-tools/visualize.py

# 统计信息
./scripts/state-tools/stats.sh

# 直接查看文件
cat state/manifest.json
cat state/active-task.md
```

### Q: 可以删除旧的 Session 吗？

**A:** 可以但不建议。如需清理：
```bash
mkdir -p state/sessions/archive
mv state/sessions/old-session.md state/sessions/archive/
```

## 协作问题

### Q: 多人如何协作？

**A:**
1. 通过 git 同步 `state/` 目录
2. 在 `task-tree.md` 明确任务分配
3. 频繁 commit/push

### Q: 出现冲突怎么办？

**A:**
- **manifest.json**: 手动合并，保留最新状态
- **Markdown**: 简单合并双方修改
- **预防**: 更频繁地同步，避免长时间工作

### Q: 可以在不同机器上使用吗？

**A:** 可以！只要通过 git 同步状态文件即可。

## 故障排查

### Q: Agent 没有读取状态？

**A:** 检查：
1. 文件路径正确
2. 文件存在
3. Agent 有 Read 权限
4. 告诉 Agent "请先读取项目状态"

### Q: 验证脚本报错？

**A:**
```bash
# 检查 JSON 格式
jq . state/manifest.json

# 检查文件存在
ls -la state/
```

### Q: 可视化工具无法运行？

**A:**
```bash
# 检查 Python 版本
python3 --version  # 需要 3.7+

# 检查文件权限
chmod +x scripts/state-tools/visualize.py
```

## 高级问题

### Q: 可以自定义状态结构吗？

**A:** 可以。`manifest.json` 支持自定义字段：
```json
{
  "custom": {
    "priority": "high",
    "deadline": "2026-03-15"
  }
}
```

### Q: 如何集成到 CI/CD？

**A:** 示例 GitHub Actions：
```yaml
- name: Validate State
  run: ./scripts/state-tools/validate.sh
```

### Q: 支持哪些 OpenClaw 版本？

**A:** 
- ✅ 2026.2.x
- ✅ 2026.3.x
- 旧版本可能需要调整

## 更多帮助

- 查看 [使用指南](usage-guide.md)
- 提交 [GitHub Issue](https://github.com/mjs618/openclaw-state-externalization/issues)
- 阅读 [示例](examples.md)
