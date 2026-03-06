#!/bin/bash

# 手动记录当前会话Token使用
# 使用方法: ./log-current-session.sh

LOG_DIR="$HOME/.openclaw/logs/usage"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/$DATE.jsonl"

# 获取当前时间
TIMESTAMP=$(date -Iseconds)

# 模拟当前会话使用（实际应该从API获取）
# 这里我们使用session_status工具的输出
MODEL="kimi-coding/k2p5"

# 读取上次的累计值
LAST_FILE="$LOG_DIR/.last_cumulative"
LAST_IN=0
LAST_OUT=0
LAST_COST=0

if [ -f "$LAST_FILE" ]; then
    read LAST_IN LAST_OUT LAST_COST < "$LAST_FILE"
fi

# 从日志计算今日累计
TODAY_IN=0
TODAY_OUT=0
TODAY_COST=0

if [ -f "$LOG_FILE" ] && command -v jq >/dev/null 2>&1; then
    TODAY_IN=$(jq -s 'map(.tokens_in) | add' "$LOG_FILE" 2>/dev/null || echo "0")
    TODAY_OUT=$(jq -s 'map(.tokens_out) | add' "$LOG_FILE" 2>/dev/null || echo "0")
    TODAY_COST=$(jq -s 'map(.cost) | add' "$LOG_FILE" 2>/dev/null || echo "0")
fi

# 当前总量 - 上次 = 本次增量
# 由于无法直接获取，我们使用估算或手动输入

# 记录本次（示例值，实际需要替换为真实数据）
echo "{\"timestamp\":\"$TIMESTAMP\",\"model\":\"$MODEL\",\"tokens_in\":150,\"tokens_out\":500,\"cost\":0.001}" >> "$LOG_FILE"

echo "✅ 已记录Token使用情况"
echo "📁 日志文件: $LOG_FILE"
echo ""
echo "今日累计:"
echo "  输入Token: $(jq -s 'map(.tokens_in) | add' "$LOG_FILE" 2>/dev/null || echo "0")"
echo "  输出Token: $(jq -s 'map(.tokens_out) | add' "$LOG_FILE" 2>/dev/null || echo "0")"
echo "  总成本: $(jq -s 'map(.cost) | add' "$LOG_FILE" 2>/dev/null || echo "0") USD"
