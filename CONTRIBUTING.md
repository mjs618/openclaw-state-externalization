## 🚀 贡献指南

感谢你对 OpenClaw State Externalization 的兴趣！

### 📋 提交 Issue

- 使用对应的 [Issue 模板](.github/ISSUE_TEMPLATE/)
- 清晰描述问题或需求
- 提供复现步骤（如果是 bug）

### 🔧 提交 PR

1. **Fork 仓库**
2. **创建分支**: `git checkout -b feature/your-feature`
3. **提交变更**: `git commit -m 'feat: 描述'`
4. **推送分支**: `git push origin feature/your-feature`
5. **创建 PR**: 使用 PR 模板

### 📝 提交规范

#### Commit 消息格式

```
类型: 简短描述

详细说明（可选）
```

**类型**:
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档更新
- `style`: 格式调整（不影响代码）
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具

#### 示例

```
feat: 添加状态可视化脚本

- 生成进度图表
- 支持导出 HTML 报告
```

### 🧪 测试

提交前请确保：

```bash
# 验证状态结构
./scripts/state-tools/validate.sh

# 检查统计
./scripts/state-tools/stats.sh
```

### 📚 文档

- 更新相关文档（README、FAQ 等）
- 添加使用示例
- 更新 CHANGELOG

### 🎯 开发路线图

查看 [Issues](../../issues) 了解：
- `good first issue`: 适合新手的任务
- `help wanted`: 需要帮助的功能
- `enhancement`: 新功能建议

### 💬 讨论

- 在 Issue 中讨论大改动
- 在 PR 中讨论实现细节

### 📜 行为准则

- 友善和尊重
- 接受建设性批评
- 关注问题本身
- 互相帮助

---

再次感谢你的贡献！🙏
