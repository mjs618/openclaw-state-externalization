#!/bin/bash
# 学习进度检查脚本

echo "📚 学习进度检查"
echo "================"
echo ""
echo "🛠️ 当前技能数: $(ls ~/.openclaw/workspace/skills/ 2>/dev/null | wc -l)"
echo ""
echo "📅 今日任务:"
echo "  [ ] 完成软考教材第1章"
echo "  [ ] 背诵计算题公式"
echo "  [ ] 练习10道选择题"
echo ""
echo "⏰ 距离5月考试还有: $(echo $(( ( $(date -d "2025-05-24" +%s) - $(date +%s) ) / 86400 )) 2>/dev/null || echo "约80") 天"
