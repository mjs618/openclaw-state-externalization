#!/bin/bash
#
# 状态验证脚本
# 检查 state/ 目录的完整性和一致性
#

set -e

STATE_DIR="${1:-./state}"
ERRORS=0
WARNINGS=0

echo "🔍 验证状态外化结构..."
echo "========================"
echo ""

# 检查必要文件
echo "📁 检查必要文件..."
REQUIRED_FILES=(
  "manifest.json"
  "README.md"
  "active-task.md"
  "task-tree.md"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$STATE_DIR/$file" ]; then
    echo "  ✅ $file"
  else
    echo "  ❌ $file (缺失)"
    ((ERRORS++))
  fi
done

# 检查必要目录
echo ""
echo "📂 检查必要目录..."
REQUIRED_DIRS=("sessions" "decisions" "context")

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$STATE_DIR/$dir" ]; then
    echo "  ✅ $dir/"
  else
    echo "  ⚠️  $dir/ (缺失，将自动创建)"
    mkdir -p "$STATE_DIR/$dir"
    ((WARNINGS++))
  fi
done

# 验证 manifest.json 格式
echo ""
echo "📋 验证 manifest.json..."
if [ -f "$STATE_DIR/manifest.json" ]; then
  if node -e "JSON.parse(require('fs').readFileSync('$STATE_DIR/manifest.json'))" 2>/dev/null; then
    echo "  ✅ JSON 格式正确"
    
    # 检查必需字段
    if jq -e '.version' "$STATE_DIR/manifest.json" >/dev/null 2>&1; then
      echo "  ✅ version 字段存在"
    else
      echo "  ⚠️  version 字段缺失"
      ((WARNINGS++))
    fi
    
    if jq -e '.current' "$STATE_DIR/manifest.json" >/dev/null 2>&1; then
      echo "  ✅ current 字段存在"
    else
      echo "  ⚠️  current 字段缺失"
      ((WARNINGS++))
    fi
  else
    echo "  ❌ JSON 格式错误"
    ((ERRORS++))
  fi
fi

# 检查 Session 文件一致性
echo ""
echo "📅 检查 Session 记录..."
LAST_SESSION=$(jq -r '.current.lastSession // empty' "$STATE_DIR/manifest.json" 2>/dev/null)
if [ -n "$LAST_SESSION" ]; then
  SESSION_FILE="$STATE_DIR/sessions/${LAST_SESSION}.md"
  if [ -f "$SESSION_FILE" ]; then
    echo "  ✅ 最新 Session 文件存在: $LAST_SESSION"
  else
    echo "  ⚠️  manifest 引用的 Session 不存在: $LAST_SESSION"
    ((WARNINGS++))
  fi
else
  echo "  ℹ️  无 Session 记录"
fi

SESSION_COUNT=$(ls -1 "$STATE_DIR/sessions/" 2>/dev/null | wc -l)
echo "  ℹ️  共有 $SESSION_COUNT 个 Session 记录"

# 检查 task_plan.md 同步
echo ""
echo "📝 检查任务计划..."
if [ -f "./task_plan.md" ]; then
  echo "  ✅ task_plan.md 存在"
else
  echo "  ⚠️  task_plan.md 缺失"
  ((WARNINGS++))
fi

# 总结
echo ""
echo "========================"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
  echo "✅ 所有检查通过！"
  exit 0
elif [ $ERRORS -eq 0 ]; then
  echo "⚠️  通过，但有 $WARNINGS 个警告"
  exit 0
else
  echo "❌ 失败: $ERRORS 个错误, $WARNINGS 个警告"
  exit 1
fi
