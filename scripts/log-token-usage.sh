#!/bin/bash

# OpenClaw Token使用记录Hook
# 在每次对话后自动记录Token消耗

LOG_DIR="$HOME/.openclaw/logs/usage"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/$DATE.jsonl"

# 从环境变量或参数获取数据
MODEL="${1:-kimi-coding/k2p5}"
TOKENS_IN="${2:-0}"
TOKENS_OUT="${3:-0}"
COST="${4:-0}"

# 记录到日志
echo "{\"timestamp\":\"$(date -Iseconds)\",\"model\":\"$MODEL\",\"tokens_in\":$TOKENS_IN,\"tokens_out\":$TOKENS_OUT,\"cost\":$COST}" >> "$LOG_FILE"

echo "已记录: $MODEL | 输入:$TOKENS_IN | 输出:$TOKENS_OUT | 成本:$$COST"
