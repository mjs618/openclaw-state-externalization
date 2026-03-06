#!/bin/bash
#
# 搜索状态内容
# 在状态文件中搜索关键词
#

PROJECT_DIR="${1:-.}"
KEYWORD="$2"

if [ -z "$KEYWORD" ]; then
  echo "用法: $0 [project-dir] <keyword>"
  exit 1
fi

echo "🔍 搜索: '$KEYWORD'"
echo "==================="
echo ""

# 在 sessions 中搜索
echo "📅 Sessions 中的匹配:"
grep -r "$KEYWORD" "$PROJECT_DIR/state/sessions/" --include="*.md" 2>/dev/null | head -10 || echo "  无匹配"

echo ""
echo "📝 决策记录中的匹配:"
grep -r "$KEYWORD" "$PROJECT_DIR/state/decisions/" --include="*.md" 2>/dev/null | head -10 || echo "  无匹配"

echo ""
echo "📚 研究发现中的匹配:"
grep "$KEYWORD" "$PROJECT_DIR/findings.md" 2>/dev/null | head -10 || echo "  无匹配"

echo ""
echo "==================="
