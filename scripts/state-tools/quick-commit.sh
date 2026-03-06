#!/bin/bash
#
# 快速提交脚本
# 自动提交状态变更到 git
#

set -e

echo "🚀 快速提交状态变更"
echo "==================="
echo ""

# 检查 git 仓库
if [ ! -d ".git" ]; then
  echo "❌ 当前目录不是 git 仓库"
  exit 1
fi

# 生成提交信息
SESSION_NUM=$(ls -1 state/sessions/ 2>/dev/null | wc -l)
if [ $SESSION_NUM -gt 0 ]; then
  LAST_SESSION=$(ls -1 state/sessions/ | sort | tail -1 | sed 's/.md$//')
  DEFAULT_MSG="Session $LAST_SESSION: 状态更新"
else
  DEFAULT_MSG="chore: 更新状态文件"
fi

# 如果提供了参数，使用参数作为提交信息
if [ -n "$1" ]; then
  COMMIT_MSG="$1"
else
  COMMIT_MSG="$DEFAULT_MSG"
fi

# 添加状态文件
echo "📁 添加变更..."
git add state/ 2>/dev/null || true
git add task_plan.md findings.md progress.md 2>/dev/null || true

# 检查是否有变更
if git diff --cached --quiet; then
  echo "ℹ️  没有需要提交的变更"
  exit 0
fi

# 显示变更摘要
echo ""
echo "📋 变更摘要:"
git diff --cached --stat

# 提交
echo ""
echo "💾 提交: $COMMIT_MSG"
git commit -m "$COMMIT_MSG"

# 询问是否推送
if [ -n "$2" ] && [ "$2" = "--push" ]; then
  echo ""
  echo "☁️  推送到远程..."
  git push
  echo "✅ 推送完成"
else
  echo ""
  echo "💡 提示: 使用 --push 参数自动推送"
  echo "   ./scripts/state-tools/quick-commit.sh '消息' --push"
fi

echo ""
echo "==================="
echo "✅ 提交完成"
