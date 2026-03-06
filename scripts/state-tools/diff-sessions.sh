#!/bin/bash
#
# 比较两个 Session 的差异
# 查看项目状态的变化
#

STATE_DIR="${1:-./state}"
SESSION1="$2"
SESSION2="$3"

if [ -z "$SESSION1" ] || [ -z "$SESSION2" ]; then
  echo "用法: $0 [state-dir] <session1> <session2>"
  echo ""
  echo "可用 Sessions:"
  ls -1 "$STATE_DIR/sessions/" 2>/dev/null | sed 's/.md$//' | head -10
  exit 1
fi

FILE1="$STATE_DIR/sessions/${SESSION1}.md"
FILE2="$STATE_DIR/sessions/${SESSION2}.md"

if [ ! -f "$FILE1" ]; then
  echo "❌ Session 不存在: $SESSION1"
  exit 1
fi

if [ ! -f "$FILE2" ]; then
  echo "❌ Session 不存在: $SESSION2"
  exit 1
fi

echo "📊 比较 Session: $SESSION1 vs $SESSION2"
echo "=========================================="
echo ""

# 显示差异
diff -u "$FILE1" "$FILE2" | head -50 || true

echo ""
echo "=========================================="
