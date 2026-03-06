# OpenClaw State Externalization

<p align="center">
  <img src="assets/images/logo.svg" alt="Logo" width="120" height="120">
</p>

<p align="center">
  <strong>跨天 · 跨 Session · 跨 Agent 的长期任务状态管理系统</strong>
</p>

<p align="center">
  <a href="https://github.com/mjs618/openclaw-state-externalization/stargazers">
    <img src="https://img.shields.io/github/stars/mjs618/openclaw-state-externalization?style=for-the-badge&color=yellow" alt="Stars">
  </a>
  <a href="https://github.com/mjs618/openclaw-state-externalization/network/members">
    <img src="https://img.shields.io/github/forks/mjs618/openclaw-state-externalization?style=for-the-badge&color=blue" alt="Forks">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/github/license/mjs618/openclaw-state-externalization?style=for-the-badge&color=green" alt="License">
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/OpenClaw-2026.3.2-blue?style=flat-square" alt="OpenClaw">
  <img src="https://img.shields.io/badge/State-v2.0-green?style=flat-square" alt="Version">
  <img src="https://img.shields.io/badge/Language-Shell/Python-orange?style=flat-square" alt="Language">
  <a href="https://mjs618.github.io/openclaw-state-externalization">
    <img src="https://img.shields.io/badge/Docs-GitHub%20Pages-blue?style=flat-square" alt="Documentation">
  </a>
</p>

<p align="center">
  <a href="README.zh-CN.md">简体中文</a> | 
  <a href="#-quick-start">Quick Start</a> | 
  <a href="#-documentation">Documentation</a> | 
  <a href="#-examples">Examples</a>
</p>

---

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/mjs618/openclaw-state-externalization.git
cd openclaw-state-externalization

# Initialize your project
./templates/state-externalization/init-state.sh "My Project" "Project description"

# Verify installation
./scripts/state-tools/validate.sh
```

## ✨ Features

- 📅 **Cross-day Persistence** - State survives session restarts
- 🔄 **Auto Recovery** - New sessions automatically restore context
- 👥 **Multi-agent Collaboration** - Git-synced state files
- 📁 **Dual Format** - JSON for machines, Markdown for humans
- 🚀 **One-click Init** - Automated project setup
- 📊 **Visualization** - Progress reports and charts

## 📖 Documentation

- 📘 [Complete Guide](state-externalization-guide.md)
- 🤖 [Agent Protocol](STATE_PROTOCOL.md)
- ❓ [FAQ](FAQ.md)
- 💡 [Best Practices](BEST_PRACTICES.md)
- 🌐 [Online Docs](https://mjs618.github.io/openclaw-state-externalization)

## 🛠️ Tools

```bash
# Validate state structure
./scripts/state-tools/validate.sh

# View statistics
./scripts/state-tools/stats.sh

# Generate visualization
./scripts/state-tools/visualize.py --format html

# Quick commit
./scripts/state-tools/quick-commit.sh "message" --push

# Export report
./scripts/state-tools/export-report.sh ./my-project report.md

# Search content
./scripts/state-tools/search.sh ./my-project "keyword"
```

## 🎯 Use Cases

| Scenario | Traditional | State Externalization |
|----------|-------------|----------------------|
| Multi-day tasks | Repeat context daily | Auto-restore |
| Team collaboration | Unclear progress | Git-synced state |
| Complex projects | Lost decisions | Permanent records |
| After restart | Start over | Continue from last |

## 📊 Architecture

```
┌─────────────────────────────────────────┐
│  AI Agent Context Window (Limited)      │
└───────────────┬─────────────────────────┘
                │ State Externalization
                ▼
┌─────────────────────────────────────────┐
│  External Storage System                │
│  ├── manifest.json (Global State)       │
│  ├── active-task.md (Current Task)      │
│  ├── sessions/ (History)                │
│  └── decisions/ (Decisions)             │
└─────────────────────────────────────────┘
```

## 📦 Project Structure

```
my-project/
├── state/
│   ├── manifest.json          # Global state
│   ├── README.md              # Project overview
│   ├── active-task.md         # Current task
│   ├── sessions/              # Session history
│   └── decisions/             # Decision records
├── task_plan.md               # Task plan
├── findings.md                # Research findings
└── progress.md                # Progress log
```

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📜 License

[MIT](LICENSE) © 2026 OpenClaw State Externalization Contributors

---

<p align="center">
  Made with ❤️ and 🤖 for better AI collaboration
</p>
