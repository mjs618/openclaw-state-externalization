#!/bin/bash
#
# 导出项目报告
# 生成完整的项目状态报告（Markdown 格式）
#

PROJECT_DIR="${1:-.}"
OUTPUT_FILE="${2:-project-report.md}"
STATE_DIR="$PROJECT_DIR/state"

echo "📊 生成项目报告..."
echo "=================="

# 获取项目信息
PROJECT_NAME=$(jq -r '.project.name // "Unknown"' "$STATE_DIR/manifest.json" 2>/dev/null)
PROJECT_STATUS=$(jq -r '.current.status // "unknown"' "$STATE_DIR/manifest.json" 2>/dev/null)
PROJECT_PHASE=$(jq -r '.current.phase // "unknown"' "$STATE_DIR/manifest.json" 2>/dev/null)
TOTAL_SESSIONS=$(ls -1 "$STATE_DIR/sessions/" 2>/dev/null | wc -l)

# 获取任务统计
TOTAL_TASKS=$(jq '.tasks | length' "$STATE_DIR/manifest.json" 2>/dev/null)
COMPLETE_TASKS=$(jq '[.tasks[] | select(.status == "complete")] | length' "$STATE_DIR/manifest.json" 2>/dev/null)
PROGRESS=$((COMPLETE_TASKS * 100 / TOTAL_TASKS))

# 生成报告
cat > "$OUTPUT_FILE" << EOF
# 📊 项目状态报告

**生成时间:** $(date '+%Y-%m-%d %H:%M:%S')

---

## 📋 项目信息

| 项目 | 内容 |
|------|------|
| **项目名称** | $PROJECT_NAME |
| **项目状态** | $PROJECT_STATUS |
| **当前阶段** | $PROJECT_PHASE |
| **Session 数** | $TOTAL_SESSIONS |

---

## 📈 任务进度

| 指标 | 数值 |
|------|------|
| **总任务** | $TOTAL_TASKS |
| **已完成** | $COMPLETE_TASKS |
| **进度** | $PROGRESS% |

**进度条:**

EOF

# 生成 ASCII 进度条
BAR_LENGTH=30
FILLED=$((BAR_LENGTH * PROGRESS / 100))
EMPTY=$((BAR_LENGTH - FILLED))
BAR="$(printf '█%.0s' $(seq 1 $FILLED))$(printf '░%.0s' $(seq 1 $EMPTY))"
echo "[$BAR] $PROGRESS%" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" << EOF

---

## 📝 最近 Session

EOF

# 添加最近 3 个 Session 的摘要
ls -1 "$STATE_DIR/sessions/" 2>/dev/null | sort | tail -3 | while read session_file; do
  echo "### ${session_file%.md}" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
  # 提取完成的工作部分
  sed -n '/### 完成的工作/,/### /p' "$STATE_DIR/sessions/$session_file" | head -10 >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
done

cat >> "$OUTPUT_FILE" << EOF

---

## 📁 项目文件

\`\`\`
$(tree -L 2 "$PROJECT_DIR" 2>/dev/null || find "$PROJECT_DIR" -maxdepth 2 -type f | head -20)
\`\`\`

---

*报告由 OpenClaw State Externalization 自动生成*
EOF

echo ""
echo "✅ 报告已生成: $OUTPUT_FILE"
echo ""
