#!/bin/bash
#
# 归档完成的项目
# 将已完成的项目归档到 archive 目录
#

PROJECT_DIR="${1:-.}"
ARCHIVE_DIR="${2:-./archived-projects}"

echo "📦 归档项目..."
echo "=============="

# 获取项目名
PROJECT_NAME=$(jq -r '.project.name // "unknown"' "$PROJECT_DIR/state/manifest.json" 2>/dev/null)
ARCHIVE_NAME="${PROJECT_NAME}-$(date +%Y%m%d)"
ARCHIVE_PATH="$ARCHIVE_DIR/$ARCHIVE_NAME"

echo "项目名: $PROJECT_NAME"
echo "归档路径: $ARCHIVE_PATH"

# 创建归档目录
mkdir -p "$ARCHIVE_PATH"

# 复制关键文件
cp -r "$PROJECT_DIR/state" "$ARCHIVE_PATH/"
cp "$PROJECT_DIR/task_plan.md" "$ARCHIVE_PATH/" 2>/dev/null
cp "$PROJECT_DIR/findings.md" "$ARCHIVE_PATH/" 2>/dev/null
cp "$PROJECT_DIR/progress.md" "$ARCHIVE_PATH/" 2>/dev/null

# 创建归档说明
cat > "$ARCHIVE_PATH/ARCHIVE.md" << EOF
# 项目归档

**项目名:** $PROJECT_NAME
**归档日期:** $(date '+%Y-%m-%d %H:%M:%S')
**状态:** 已完成

## 归档内容

- state/ - 完整状态记录
- task_plan.md - 任务计划
- findings.md - 研究发现
- progress.md - 进度日志

## 如何恢复

\`\`\`bash
cp -r $ARCHIVE_NAME/state ./new-project/
# 然后重新初始化
\`\`\`
EOF

echo ""
echo "✅ 项目已归档到: $ARCHIVE_PATH"
echo ""
