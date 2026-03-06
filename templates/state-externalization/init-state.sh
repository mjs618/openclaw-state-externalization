#!/bin/bash
#
# State Externalization Init Script
# Usage: ./init-state.sh <project-name> [project-description]
#

set -e

PROJECT_NAME="${1:-my-project}"
PROJECT_DESC="${2:-A new project using OpenClaw state externalization}"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
DATE_PREFIX=$(date +"%Y-%m-%d")
TEMPLATE_DIR="${CLAUDE_PLUGIN_ROOT:-$HOME/.openclaw/workspace}/templates/state-externalization"

echo "🚀 初始化项目状态外化结构: $PROJECT_NAME"
echo "================================"

# 创建目录结构
mkdir -p state/{decisions,sessions,context}
echo "✅ 目录结构创建完成"

# 复制并填充模板
cp "$TEMPLATE_DIR/manifest.json" state/manifest.json
cp "$TEMPLATE_DIR/README.md" state/README.md
cp "$TEMPLATE_DIR/active-task.md" state/active-task.md

# 填充变量
sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" state/manifest.json
sed -i "s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESC/g" state/manifest.json
sed -i "s/{{TIMESTAMP}}/$TIMESTAMP/g" state/manifest.json

sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" state/README.md
sed -i "s/{{PROJECT_DESCRIPTION}}/$PROJECT_DESC/g" state/README.md
sed -i "s/{{TIMESTAMP}}/$TIMESTAMP/g" state/README.md

sed -i "s/{{TASK_ID}}/task-001/g" state/active-task.md
sed -i "s/{{TASK_NAME}}/初始任务/g" state/active-task.md
sed -i "s/{{TIMESTAMP}}/$TIMESTAMP/g" state/active-task.md
sed -i "s/{{OWNER}}/agent:main/g" state/active-task.md

# 创建首次 Session 记录
SESSION_FILE="state/sessions/${DATE_PREFIX}-001.md"
cp "$TEMPLATE_DIR/sessions/session-template.md" "$SESSION_FILE"
sed -i "s/{{SESSION_ID}}/$DATE_PREFIX-001/g" "$SESSION_FILE"
sed -i "s/{{START_TIME}}/$TIMESTAMP/g" "$SESSION_FILE"
sed -i "s/{{END_TIME}}/进行中/g" "$SESSION_FILE"
sed -i "s/{{TASK_ID}}/task-001/g" "$SESSION_FILE"

# 创建基础 planning 文件
cat > task_plan.md << 'EOF'
# Task Plan: 任务计划

## 项目概览
- **项目名称**: PROJECT_NAME
- **目标**: PROJECT_DESCRIPTION

## 任务列表
- [ ] 任务 1: 初始化和规划
- [ ] 任务 2: （待定义）
- [ ] 任务 3: （待定义）

## 当前阶段
阶段: 初始化

## 错误记录
| 错误 | 尝试 | 解决 |
|------|------|------|
| 无 | - | - |
EOF

sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" task_plan.md
sed -i "s/PROJECT_DESCRIPTION/$PROJECT_DESC/g" task_plan.md

cat > findings.md << 'EOF'
# Findings: 研究发现

## 关键发现
（在此记录所有重要发现）

## 参考资料
- [链接名称](URL) - 描述

## 代码片段
```python
# 示例代码
```
EOF

cat > progress.md << 'EOF'
# Progress: 进度日志

## 会话记录

### TIMESTAMP - Session 001
- 状态: 项目初始化
- 成果: 创建了状态外化结构
- 下一步: 定义具体任务目标
EOF

sed -i "s/TIMESTAMP/$TIMESTAMP/g" progress.md

# 创建 task-tree.md
cat > state/task-tree.md << 'EOF'
# 任务树

```
my-project/
└── task-001: 初始任务 [进行中]
    ├── task-002: （待拆分）
    └── task-003: （待拆分）
```

## 任务详情

### task-001: 初始任务
- 状态: in_progress
- 负责人: agent:main
- 优先级: P0
- 开始: TIMESTAMP
EOF

sed -i "s/TIMESTAMP/$TIMESTAMP/g" state/task-tree.md

echo ""
echo "✅ 项目初始化完成！"
echo ""
echo "📁 创建的目录结构:"
tree state 2>/dev/null || find state -type f | head -20
echo ""
echo "📝 关键文件:"
echo "  - state/manifest.json     (全局状态)"
echo "  - state/README.md         (项目概览)"
echo "  - state/active-task.md    (当前任务)"
echo "  - task_plan.md            (任务计划)"
echo "  - findings.md             (研究发现)"
echo "  - progress.md             (进度日志)"
echo ""
echo "🚀 下次启动时，AI Agent 会自动读取 state/ 目录恢复上下文"
