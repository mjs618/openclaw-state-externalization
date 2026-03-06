#!/bin/bash

# Token使用记录脚本
# 记录每次对话的Token消耗

LOG_DIR="$HOME/.openclaw/logs/usage"
mkdir -p "$LOG_DIR"

DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/$DATE.jsonl"

# 记录当前会话使用（模拟从API获取）
# 实际使用时，这个脚本应该在每次对话后由OpenClaw调用

record_usage() {
    local model=$1
    local tokens_in=$2
    local tokens_out=$3
    local cost=$4
    local timestamp=$(date -Iseconds)
    
    echo "{\"timestamp\":\"$timestamp\",\"model\":\"$model\",\"tokens_in\":$tokens_in,\"tokens_out\":$tokens_out,\"cost\":$cost}" >> "$LOG_FILE"
}

# 获取今日统计
get_today_stats() {
    if [ ! -f "$LOG_FILE" ]; then
        echo "0 0 0 0.0000"
        return
    fi
    
    local total_in=$(jq -s 'map(.tokens_in) | add' "$LOG_FILE" 2>/dev/null || echo "0")
    local total_out=$(jq -s 'map(.tokens_out) | add' "$LOG_FILE" 2>/dev/null || echo "0")
    local total_cost=$(jq -s 'map(.cost) | add' "$LOG_FILE" 2>/dev/null || echo "0")
    
    echo "$total_in $total_out $((total_in + total_out)) $total_cost"
}

# 命令行接口
case "${1:-stats}" in
    record)
        record_usage "$2" "$3" "$4" "$5"
        ;;
    stats)
        get_today_stats
        ;;
    *)
        echo "用法: $0 {record|stats}"
        ;;
esac
