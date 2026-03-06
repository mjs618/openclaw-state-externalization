#!/bin/bash

# 每日总结笔记生成脚本 - 自动发送版
# 每天23:59自动创建今日总结笔记并发送通知

VAULT_PATH="$HOME/.openclaw/workspace/obsidian-vault/学习笔记/日记"
USAGE_LOG="$HOME/.openclaw/logs/usage"
DATE=$(date +%Y-%m-%d)
WEEKDAY=$(date +%A)
YEAR_MONTH=$(date +%Y-%m)
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v-1d +%Y-%m-%d 2>/dev/null)

# Feishu Webhook 配置 (需要用户配置)
FEISHU_WEBHOOK_URL="${FEISHU_WEBHOOK_URL:-}"

# 创建日记文件
NOTE_FILE="$VAULT_PATH/$DATE.md"

# 如果文件已存在，不覆盖
if [ -f "$NOTE_FILE" ]; then
    echo "笔记已存在: $NOTE_FILE"
    exit 0
fi

# 获取当前技能数量
CURRENT_SKILLS_COUNT=0
if command -v clawhub &> /dev/null; then
    CURRENT_SKILLS_COUNT=$(clawhub list 2>/dev/null | wc -l)
fi

# 获取昨日技能数量
YESTERDAY_SKILLS_COUNT=0
YESTERDAY_FILE="$VAULT_PATH/$YESTERDAY.md"
if [ -f "$YESTERDAY_FILE" ]; then
    YESTERDAY_SKILLS_COUNT=$(grep -o "总技能数.*[0-9]" "$YESTERDAY_FILE" | grep -o "[0-9]*" | head -1 || echo "0")
fi

# 计算今日新增技能
NEW_SKILLS_COUNT=$((CURRENT_SKILLS_COUNT - YESTERDAY_SKILLS_COUNT))
[ $NEW_SKILLS_COUNT -lt 0 ] && NEW_SKILLS_COUNT=0

# 从日志获取今日Token统计
TODAY_LOG="$USAGE_LOG/$DATE.jsonl"
TODAY_TOKENS_IN=0
TODAY_TOKENS_OUT=0
TODAY_TOKENS_TOTAL=0
TODAY_COST_USD=0

if [ -f "$TODAY_LOG" ] && command -v jq >/dev/null 2>&1; then
    TODAY_TOKENS_IN=$(jq -s 'map(.tokens_in) | add' "$TODAY_LOG" 2>/dev/null || echo "0")
    TODAY_TOKENS_OUT=$(jq -s 'map(.tokens_out) | add' "$TODAY_LOG" 2>/dev/null || echo "0")
    TODAY_COST_USD=$(jq -s 'map(.cost) | add' "$TODAY_LOG" 2>/dev/null || echo "0")
    TODAY_TOKENS_TOTAL=$((TODAY_TOKENS_IN + TODAY_TOKENS_OUT))
fi

# 转换为人民币（汇率7.2）
TODAY_COST=$(printf "%.4f" $(echo "$TODAY_COST_USD * 7.2" | bc 2>/dev/null || echo "0"))

# 预算计算
BUDGET=5.0
REMAINING=$(printf "%.2f" $(echo "$BUDGET - $TODAY_COST" | bc 2>/dev/null || echo "$BUDGET"))
BUDGET_PERCENT=$(printf "%.1f" $(echo "$TODAY_COST / $BUDGET * 100" | bc 2>/dev/null || echo "0"))

# 预算状态
if (( $(echo "$BUDGET_PERCENT < 20" | bc -l 2>/dev/null) )); then
    BUDGET_STATUS="🟢"
elif (( $(echo "$BUDGET_PERCENT < 50" | bc -l 2>/dev/null) )); then
    BUDGET_STATUS="🟡"
elif (( $(echo "$BUDGET_PERCENT < 80" | bc -l 2>/dev/null) )); then
    BUDGET_STATUS="🟠"
else
    BUDGET_STATUS="🔴"
fi

# 成长趋势
if [ $NEW_SKILLS_COUNT -eq 0 ]; then
    GROWTH_TREND="➡️ 保持稳定"
elif [ $NEW_SKILLS_COUNT -lt 3 ]; then
    GROWTH_TREND="📈 +$NEW_SKILLS_COUNT"
elif [ $NEW_SKILLS_COUNT -lt 10 ]; then
    GROWTH_TREND="🚀 +$NEW_SKILLS_COUNT"
else
    GROWTH_TREND="🔥 +$NEW_SKILLS_COUNT"
fi

# 创建笔记内容
cat > "$NOTE_FILE" << 'EOF'
# $DATE $WEEKDAY - 今日总结

## 📊 今日概览
> 一天结束，回顾收获与成长

| 指标 | 数值 | 趋势 |
|:---|---:|:---|
| 🛠️ 总技能数 | $CURRENT_SKILLS_COUNT | $GROWTH_TREND |
| 💰 今日成本 | ¥$TODAY_COST | $BUDGET_STATUS 健康 |
| 📝 Token消耗 | $TODAY_TOKENS_TOTAL | 输入$TODAY_TOKENS_IN / 输出$TODAY_TOKENS_OUT |
| 📊 预算使用 | ${BUDGET_PERCENT}% | 剩余 ¥$REMAINING |

---

## 💰 成本与Token统计

### 📈 今日消耗概览
\`\`\`
输入Token:  $TODAY_TOKENS_IN  tokens
输出Token:  $TODAY_TOKENS_OUT tokens
总计Token:  $TODAY_TOKENS_TOTAL tokens
今日成本:   ¥$TODAY_COST
\`\`\`

### 💵 预算使用情况
| 项目 | 金额/数量 | 占比 | 状态 |
|:---|---:|---:|:---|
| 今日成本 | ¥$TODAY_COST | ${BUDGET_PERCENT}% | $BUDGET_STATUS 健康 |
| 剩余预算 | ¥$REMAINING | ${REMAINING_PERCENT}% | 充足 |

---

## ✅ 今日完成事项
- [ ] 技能学习 (安装 $NEW_SKILLS_COUNT 个新技能)
- [ ] Token消耗: $TODAY_TOKENS_TOTAL
- [ ] 成本控制: ¥$TODAY_COST / ¥5.00

---

## 🛠️ 技能成长中心

### 🎯 技能分类全景
| 类别 | 数量 | 核心技能 | 熟练度 |
|:---|:---:|:---|:---:|
| 🧠 认知记忆 | 5 | elite-longterm-memory, adaptive-reasoning, learning | ⭐⭐⭐⭐ |
| 💻 编程开发 | 6 | code, git-essentials, database-operations | ⭐⭐⭐⭐⭐ |
| 🔍 研究分析 | 6 | deep-research-pro, data-analysis, analysis | ⭐⭐⭐⭐ |
| ✍️ 写作创作 | 5 | writing, translate, xiaohongshu-writing | ⭐⭐⭐⭐ |
| 🤖 自动化工具 | 5 | ai-web-automation, agent-browser, cloud | ⭐⭐⭐ |
| 🖼️ 媒体处理 | 3 | image, sag, pdf-extract | ⭐⭐⭐ |
| 🔧 效率工具 | 12+ | github, notion, obsidian 等 | ⭐⭐⭐⭐ |
| **📦 总计** | **$CURRENT_SKILLS_COUNT** | - | **⭐⭐⭐⭐** |

---

## 📚 深度学习记录

### 🧠 今日习得
| 技能 | Token消耗 | 掌握程度 | 笔记 |
|:---|:---:|:---:|:---|
| | - | ⭐⭐⭐ | |

### 💭 关键洞见
- 

---

## 🌟 明日规划
- [ ] 

---

*🌙 总结于: $(date "+%Y-%m-%d %H:%M") | 技能: $CURRENT_SKILLS_COUNT | 成本: ¥$TODAY_COST | $GROWTH_TREND*

#学习笔记 #今日总结 #技能成长 #成本统计 #$YEAR_MONTH
EOF

# 替换变量
sed -i "s/\$DATE/$DATE/g" "$NOTE_FILE"
sed -i "s/\$WEEKDAY/$WEEKDAY/g" "$NOTE_FILE"
sed -i "s/\$YEAR_MONTH/$YEAR_MONTH/g" "$NOTE_FILE"
sed -i "s/\$CURRENT_SKILLS_COUNT/$CURRENT_SKILLS_COUNT/g" "$NOTE_FILE"
sed -i "s/\$NEW_SKILLS_COUNT/$NEW_SKILLS_COUNT/g" "$NOTE_FILE"
sed -i "s/\$TODAY_COST/$TODAY_COST/g" "$NOTE_FILE"
sed -i "s/\$TODAY_TOKENS_IN/$TODAY_TOKENS_IN/g" "$NOTE_FILE"
sed -i "s/\$TODAY_TOKENS_OUT/$TODAY_TOKENS_OUT/g" "$NOTE_FILE"
sed -i "s/\$TODAY_TOKENS_TOTAL/$TODAY_TOKENS_TOTAL/g" "$NOTE_FILE"
sed -i "s/\$BUDGET_PERCENT/$BUDGET_PERCENT/g" "$NOTE_FILE"
sed -i "s/\$REMAINING/$REMAINING/g" "$NOTE_FILE"
sed -i "s/\$REMAINING_PERCENT/$REMAINING_PERCENT/g" "$NOTE_FILE"
sed -i "s/\$BUDGET_STATUS/$BUDGET_STATUS/g" "$NOTE_FILE"
sed -i "s/\$GROWTH_TREND/$GROWTH_TREND/g" "$NOTE_FILE"

# 添加技能清单
clawhub list 2>/dev/null >> "$NOTE_FILE" || echo "技能列表获取中..." >> "$NOTE_FILE"

echo "已创建今日总结: $NOTE_FILE"

# ============================================
# 发送通知 (如果配置了 Webhook)
# ============================================

if [ -n "$FEISHU_WEBHOOK_URL" ]; then
    # 构建发送的消息摘要
    SUMMARY="📚 今日学习日记已生成

📊 今日概览
• 总技能数: $CURRENT_SKILLS_COUNT $GROWTH_TREND
• 今日成本: ¥$TODAY_COST $BUDGET_STATUS
• Token消耗: $TODAY_TOKENS_TOTAL (入$TODAY_TOKENS_IN / 出$TODAY_TOKENS_OUT)
• 预算使用: ${BUDGET_PERCENT}% (剩余 ¥$REMAINING)

💡 完整笔记已保存至:
$NOTE_FILE

#学习日记 #今日总结"

    # 发送 Feishu 消息
    curl -s -X POST "$FEISHU_WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -d "{
            \"msg_type\": \"text\",
            \"content\": {
                \"text\": \"$SUMMARY\"
            }
        }" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "✅ 已发送 Feishu 通知"
    else
        echo "❌ Feishu 通知发送失败"
    fi
else
    echo "ℹ️ 未配置 FEISHU_WEBHOOK_URL，跳过发送通知"
    echo "   配置方法: export FEISHU_WEBHOOK_URL='https://open.feishu.cn/open-apis/bot/v2/hook/xxxx'"
fi

# 备用方案：创建标记文件供 OpenClaw 检测发送
MARKER_FILE="$HOME/.openclaw/workspace/.daily-note-pending"
echo "$NOTE_FILE" > "$MARKER_FILE"
echo "📝 已创建发送标记: $MARKER_FILE"

echo "今日统计: 技能$CURRENT_SKILLS_COUNT个 | Token$TODAY_TOKENS_TOTAL | 成本¥$TODAY_COST"
