# 🧠 OpenClaw State Externalization

<p align="center">
  <strong>跨天·跨 Session·跨 Agent 的长期任务状态管理系统</strong>
</p>

<p align="center">
  <a href="#-快速开始">🚀 快速开始</a> •
  <a href="#-核心特性">✨ 特性</a> •
  <a href="#-工作原理">🔧 原理</a> •
  <a href="#-完整指南">📖 文档</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/OpenClaw-2026.3.2-blue?style=flat-square" alt="OpenClaw">
  <img src="https://img.shields.io/badge/State-v2.0-green?style=flat-square" alt="State Version">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=flat-square" alt="License">
</p>

---

## 🤔 为什么需要状态外化？

> **场景 1**: 你在做一个复杂项目，AI Agent 处理到一半，Token 耗尽了，重启后它把之前的进度全忘了...
>
> **场景 2**: 任务需要跨多天完成，每次打开都要重新解释上下文...
>
> **场景 3**: 多个 Agent 协作，一个 Agent 不知道另一个 Agent 做了什么...

**State Externalization** 把任务状态从"易失的上下文窗口"搬到"持久的外部存储", 实现真正的**跨 Session 记忆**。

---

## 🚀 快速开始

### 方式 1: 一键初始化（推荐）

```bash
# 克隆仓库
git clone https://github.com/mjs618/openclaw-state-externalization.git
cd openclaw-state-externalization

# 初始化你的项目
./templates/state-externalization/init-state.sh "我的项目" "项目描述"
```

### 方式 2: 手动复制模板

```bash
# 1. 复制模板到你的项目
cp -r templates/state-externalization/* your-project/

# 2. 创建状态目录
mkdir -p state/{decisions,sessions,context}

# 3. 填充模板变量（手动或使用脚本）
```

### 方式 3: AI Agent 自动处理

告诉你的 OpenClaw Agent:

> "请帮我初始化状态外化结构，项目名是 xxx"

Agent 会自动:
1. 创建目录结构
2. 填充模板变量
3. 生成初始状态文件

---

## ✨ 核心特性

| 特性 | 说明 | 效果 |
|------|------|------|
| 📅 **跨天持久化** | 状态存储在文件系统，不随 Session 结束丢失 | 任务可以持续数天 |
| 🔄 **自动恢复** | 新 Session 自动读取上次状态 | 无需重复解释上下文 |
| 👥 **多人协作** | 状态文件可 git 同步，多人/多 Agent 协作 | 团队协作无摩擦 |
| 📁 **双格式存储** | JSON（机器）+ Markdown（人） | 兼顾自动化和可读性 |
| 🚀 **一键初始化** | 脚本自动创建完整结构 | 5 秒启动新项目 |
| 📊 **状态可视化** | 清晰的进度和任务树 | 随时了解全局 |

---

## 🔧 工作原理

### 三层架构

```
┌─────────────────────────────────────────────────────────┐
│  Layer 1: 超大上下文模型                                 │
│  - Kimi (200万 Token), Claude (100万), Gemini (200万)   │
│  - 缺点: 贵、Lost-in-the-middle                         │
├─────────────────────────────────────────────────────────┤
│  Layer 2: Session Compaction                             │
│  - OpenClaw 原生机制，自动压缩历史                       │
│  - 缺点: 重启后仍可能丢失上下文                          │
├─────────────────────────────────────────────────────────┤
│  Layer 3: 状态外化 ⭐ （本方案）                         │
│  - 关键状态写入外部文件                                  │
│  - 新 Session 自动恢复                                   │
│  - 优点: 持久、协作、可控                                │
└─────────────────────────────────────────────────────────┘
```

### Session 生命周期

```
Session 启动
    │
    ▼
┌───────────────┐
│ 读取 manifest │ ← 了解全局状态
│ 读取 README   │ ← 了解项目概览
│ 读取任务文件  │ ← 获取当前任务
│ 读取 Session  │ ← 了解上次状态
└───────────────┘
    │
    ▼
 执行任务
    │
    ▼
┌───────────────┐
│ 更新 task_plan│
│ 追加 findings │
│ 记录 progress │
│ 创建 Session  │
│ 更新 manifest │
└───────────────┘
    │
    ▼
Session 结束
```

---

## 📁 目录结构

```
my-project/
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

## 📖 完整指南

| 文档 | 内容 | 适合 |
|------|------|------|
| [📘 完整指南](state-externalization-guide.md) | 架构设计、工作原理、高级用法 | 深度用户 |
| [🤖 Agent 协议](STATE_PROTOCOL.md) | AI Agent 记忆卡片，启动/结束流程 | Agent 开发者 |
| [📁 模板目录](templates/state-externalization/) | 可复用的模板文件 | 快速开始 |
| [💡 示例项目](state/) | 已初始化的演示项目 | 参考学习 |

---

## 🎯 使用场景

### 场景 1: 代码重构项目
- 持续时间: 3-5 天
- 痛点: 每天重启都要重新理解代码库
- 解决: 每天 Session 记录进度，下次自动恢复

### 场景 2: 多人协作开发
- 参与者: 2-3 个 Agent + 人类
- 痛点: 不知道对方做了什么
- 解决: 通过 git 同步 state/ 目录

### 场景 3: 复杂研究任务
- 持续时间: 数周
- 痛点: 中间发现容易丢失
- 解决: findings.md 持续记录

---

## 🛠️ 进阶配置

### 自动化 Hooks

配置 `.openclaw/hooks/session-start.yaml`:

```yaml
on: session_start
tasks:
  - read: state/manifest.json
  - read: state/active-task.md
  - run: generate-status-summary
```

### Git 自动提交

```bash
# 启用自动提交
git config --local state.autoCommit true
```

---

## 🤝 贡献

欢迎提交 Issue 和 PR！

### 待办事项

- [ ] VS Code 插件
- [ ] 状态可视化工具
- [ ] 更多语言模板
- [ ] Web UI 管理界面

---

## 📜 License

MIT License - 自由使用，保留署名

---

<p align="center">
  用 ❤️ 和 🤖 构建
</p>
