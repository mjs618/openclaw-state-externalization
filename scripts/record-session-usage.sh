#!/bin/bash

# 记录当前会话的Token使用情况
# 由OpenClaw在每次对话后调用

LOG_DIR="$HOME/.openclaw/logs/usage"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/$DATE.jsonl"

# 从session_status获取当前使用数据
SESSION_DATA=$(openclaw session status --json 2>/dev/null || echo '{}')

# 提取数据
TOKENS_IN=$(echo "$SESSION_DATA" | jq -r '.tokensIn // 0')
TOKENS_OUT=$(echo "$SESSION_DATA" | jq -r '.tokensOut // 0')
COST=$(echo "$SESSION_DATA" | jq -r '.cost // 0')
MODEL=$(echo "$SESSION_DATA" | jq -r '.model // "unknown"')

# 计算本次增量
LAST_LOG="$LOG_DIR/.last_session"
LAST_IN=0
LAST_OUT=0

if [ -f "$LAST_LOG" ]; then
    LAST_IN=$(cat "$LAST_LOG" | cut -d' ' -f1)
    LAST_OUT=$(cat "$LAST_LOG" | cut -d' ' -f2)
fi

# 计算增量
DELTA_IN=$((TOKENS_IN - LAST_IN))
DELTA_OUT=$((TOKENS_OUT - LAST_OUT))

# 如果增量大于0，记录
if [ $DELTA_IN -gt 0 ] || [ $DELTA_OUT -gt 0 ]; then
    echo "{\"timestamp\":\"$(date -Iseconds)\",\"model\":\"$MODEL\",\"tokens_in\":$DELTA_IN,\"tokens_out\":$DELTA_OUT,\"cost\":$COST}" >> "$LOG_FILE"
fi

# 保存当前总量
echo "$TOKENS_IN $TOKENS_OUT" > "$LAST_LOG"
