#!/bin/bash
#
# Session 统计脚本
# 分析项目 Session 历史，生成统计报告
#

STATE_DIR="${1:-./state}"

echo "📊 Session 统计报告"
echo "===================="
echo ""

# 基本统计
echo "📈 基本统计"
echo "-----------"
SESSION_COUNT=$(ls -1 "$STATE_DIR/sessions/" 2>/dev/null | wc -l)
echo "总 Session 数: $SESSION_COUNT"

if [ $SESSION_COUNT -gt 0 ]; then
  FIRST_SESSION=$(ls -1 "$STATE_DIR/sessions/" | sort | head -1)
  LAST_SESSION=$(ls -1 "$STATE_DIR/sessions/" | sort | tail -1)
  echo "首个 Session: ${FIRST_SESSION%.md}"
  echo "最新 Session: ${LAST_SESSION%.md}"
fi

# 当前状态
echo ""
echo "🎯 当前状态"
echo "-----------"
if [ -f "$STATE_DIR/manifest.json" ]; then
  STATUS=$(jq -r '.current.status // "unknown"' "$STATE_DIR/manifest.json")
  PHASE=$(jq -r '.current.phase // "unknown"' "$STATE_DIR/manifest.json")
  ACTIVE_TASK=$(jq -r '.current.activeTask // "none"' "$STATE_DIR/manifest.json")
  
  echo "状态: $STATUS"
  echo "阶段: $PHASE"
  echo "激活任务: $ACTIVE_TASK"
fi

# 任务统计
echo ""
echo "📋 任务统计"
echo "-----------"
if [ -f "$STATE_DIR/manifest.json" ]; then
  TOTAL_TASKS=$(jq '.tasks | length' "$STATE_DIR/manifest.json")
  COMPLETE_TASKS=$(jq '[.tasks[] | select(.status == "complete")] | length' "$STATE_DIR/manifest.json")
  IN_PROGRESS=$(jq '[.tasks[] | select(.status == "in_progress")] | length' "$STATE_DIR/manifest.json")
  
  echo "总任务: $TOTAL_TASKS"
  echo "已完成: $COMPLETE_TASKS"
  echo "进行中: $IN_PROGRESS"
  echo "待开始: $((TOTAL_TASKS - COMPLETE_TASKS - IN_PROGRESS))"
  
  if [ $TOTAL_TASKS -gt 0 ]; then
    PROGRESS=$((COMPLETE_TASKS * 100 / TOTAL_TASKS))
    echo "整体进度: $PROGRESS%"
  fi
fi

# Session 活跃度（按日期）
echo ""
echo "📅 Session 活跃度"
echo "---------------"
ls -1 "$STATE_DIR/sessions/" 2>/dev/null | sed 's/-[0-9]*.md$//' | sort | uniq -c | sort -rn | head -10 | while read count date; do
  echo "$date: $count 个 Session"
done

# 决策记录数
echo ""
echo "💭 决策记录"
echo "-----------"
DECISION_COUNT=$(ls -1 "$STATE_DIR/decisions/" 2>/dev/null | wc -l)
echo "决策记录数: $DECISION_COUNT"

echo ""
echo "===================="
echo "统计完成"
