# OpenClaw State Externalization

[![GitHub stars](https://img.shields.io/github/stars/mjs618/openclaw-state-externalization?style=flat-square)](https://github.com/mjs618/openclaw-state-externalization/stargazers)
[![GitHub license](https://img.shields.io/github/license/mjs618/openclaw-state-externalization?style=flat-square)](LICENSE)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-2026.3.2-blue?style=flat-square)](https://github.com/openclaw/openclaw)
[![Documentation](https://img.shields.io/badge/docs-GitHub%20Pages-green?style=flat-square)](https://mjs618.github.io/openclaw-state-externalization)

<p align="center">
  <strong>跨天 · 跨 Session · 跨 Agent 的长期任务状态管理系统</strong>
</p>

[English](README.md) | [中文](README.zh-CN.md)

---

## 🚀 快速开始

```bash
# 克隆仓库
git clone https://github.com/mjs618/openclaw-state-externalization.git

# 初始化你的项目
./templates/state-externalization/init-state.sh "项目名称" "项目描述"

# 验证安装
./scripts/state-tools/validate.sh
```

## ✨ 核心特性

- 📅 **跨天持久化** - 任务状态不随 Session 结束而丢失
- 🔄 **自动恢复** - 新 Session 自动读取上次状态
- 👥 **多人协作** - 状态文件可 git 同步，多人/多 Agent 协作
- 📁 **双格式存储** - JSON（机器）+ Markdown（人）
- 🚀 **一键初始化** - 脚本自动创建完整结构
- 📊 **状态可视化** - 生成进度报告和图表

## 📖 文档

- [📘 完整指南](state-externalization-guide.md)
- [🤖 Agent 协议](STATE_PROTOCOL.md)
- [❓ 常见问题](FAQ.md)
- [💡 最佳实践](BEST_PRACTICES.md)
- [📚 在线文档](https://mjs618.github.io/openclaw-state-externalization)

## 🎯 使用场景

| 场景 | 传统方式 | 状态外化 |
|------|---------|---------|
| 跨天任务 | 每天重复解释上下文 | 自动恢复，直接继续 |
| 多人协作 | 不知道对方做了什么 | 状态文件实时同步 |
| 复杂项目 | 决策和发现容易丢失 | 永久记录在案 |
| 需要重启 | 状态全丢 | 从上次继续 |

## 📦 项目结构

```
my-project/
├── state/
│   ├── manifest.json          # 全局状态
│   ├── README.md              # 项目概览
│   ├── active-task.md         # 当前任务
│   ├── sessions/              # Session 历史
│   └── decisions/             # 决策记录
├── task_plan.md               # 任务计划
├── findings.md                # 研究发现
└── progress.md                # 进度日志
```

## 🔧 工具脚本

```bash
# 验证状态结构
./scripts/state-tools/validate.sh

# 查看统计信息
./scripts/state-tools/stats.sh

# 快速提交变更
./scripts/state-tools/quick-commit.sh "消息" --push

# 生成可视化报告
./scripts/state-tools/visualize.py --format html
```

## 🤝 贡献

欢迎提交 Issue 和 PR！查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详情。

## 📜 License

[MIT](LICENSE) © 2026 OpenClaw State Externalization Contributors
