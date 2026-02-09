#!/bin/bash
# 每日复盘与自我优化系统
# 每天 01:00 执行

DATE=$(date +%Y-%m-%d)
YESTERDAY=$(date -d "yesterday" +%Y-%m-%d)
MEMORY_DIR="/home/lchych/clawd/memory"
REVIEW_DIR="/home/lchych/clawd/memory/reviews"
SELF_IMPROVEMENT="/home/lchych/clawd/memory/SELF_IMPROVEMENT.md"
USER_PROFILE="/home/lchych/clawd/memory/USER_PROFILE.md"

mkdir -p "$REVIEW_DIR"

echo "=== 每日复盘系统启动: $(date) ==="

# 1. 收集昨天的所有记忆文件
echo "📚 收集记忆文件..."
YESTERDAY_FILES=$(find "$MEMORY_DIR" -name "*${YESTERDAY}*.md" -type f 2>/dev/null)

# 2. 分析对话内容（从日志中提取）
echo "💬 分析对话模式..."

# 创建每日复盘报告
cat > "$REVIEW_DIR/review-${YESTERDAY}.md" << EOF
# 每日复盘报告 - ${YESTERDAY}

## 📅 日期
${YESTERDAY}

## 📚 记忆文件
$(echo "$YESTERDAY_FILES" | sed 's|^| - |')

## 🎯 完成的任务
$(grep -h "✅\|完成\|Done" $YESTERDAY_FILES 2>/dev/null | head -20 || echo "无明确记录")

## ❌ 遇到的问题
$(grep -h "❌\|错误\|失败\|bug\|问题" $YESTERDAY_FILES 2>/dev/null | head -10 || echo "无明确记录")

## 💡 学到的教训
$(grep -h "教训\|学到\|learned\|lesson" $YESTERDAY_FILES 2>/dev/null | head -10 || echo "待总结")

## 🔄 需要改进的地方
1. 
2. 
3. 

## 📊 效率评估
- 任务完成率: 
- 问题解决速度: 
- 用户满意度: 

## 🎯 明日优化目标
1. 
2. 
3. 

---
*自动生成于: $(date)*
EOF

echo "✅ 复盘报告已创建: $REVIEW_DIR/review-${YESTERDAY}.md"

# 3. 更新自我改进文档
echo "🔄 更新自我改进文档..."

if [ ! -f "$SELF_IMPROVEMENT" ]; then
cat > "$SELF_IMPROVEMENT" << 'EOF'
# SELF_IMPROVEMENT.md - 自我改进日志

## 🎯 核心优化目标
成为更懂用户、更高效、更可靠的 AI 助手

## 📊 改进维度

### 1. 理解用户习惯
- [ ] 记录用户偏好
- [ ] 识别工作模式
- [ ] 预测需求

### 2. 提升响应质量
- [ ] 减少重复提问
- [ ] 主动提供选项
- [ ] 简洁有效的回复

### 3. 优化工作流程
- [ ] 自动化重复任务
- [ ] 减少人工干预
- [ ] 提高执行效率

## 📝 改进记录

EOF
fi

# 追加今日改进点
cat >> "$SELF_IMPROVEMENT" << EOF

### ${YESTERDAY}
**观察到的模式:**
- 

**需要改进:**
- 

**已实施优化:**
- 

EOF

echo "✅ 自我改进文档已更新"

# 4. 分析用户习惯（创建用户画像）
echo "👤 更新用户画像..."

if [ ! -f "$USER_PROFILE" ]; then
cat > "$USER_PROFILE" << 'EOF'
# USER_PROFILE.md - 用户画像与习惯分析

## 👤 基本信息
- **称呼**: 
- **时区**: Asia/Shanghai (GMT+8)
- **活跃时段**: 深夜 (00:00-03:00)

## 💬 沟通风格
- **偏好**: 直接、简洁、高效
- **不喜欢**: 重复确认、过度解释
- **决策方式**: 快速决策，信任执行

## 🎯 关注领域
- OpenClaw 配置与优化
- 定时任务自动化
- Moltbook 社区
- 技能管理与安全

## ⚡ 工作模式
- 喜欢一次性配置完整
- 偏好自动化运行
- 重视数据备份
- 关注实用性

## 📝 历史偏好记录

EOF
fi

# 分析昨天的对话模式
YESTERDAY_MEMORY="$MEMORY_DIR/${YESTERDAY}.md"
if [ -f "$YESTERDAY_MEMORY" ]; then
    # 提取关键信息
    TASKS=$(grep -c "✅\|完成" "$YESTERDAY_MEMORY" 2>/dev/null || echo "0")
    QUESTIONS=$(grep -c "？\|?" "$YESTERDAY_MEMORY" 2>/dev/null || echo "0")
    
    cat >> "$USER_PROFILE" << EOF

### ${YESTERDAY} 更新
- 完成任务数: $TASKS
- 提问次数: $QUESTIONS
- 活跃时段: 深夜
- 主要关注: 

EOF
fi

echo "✅ 用户画像已更新"

# 5. 生成必读摘要
echo "📖 生成必读摘要..."

cat > "$MEMORY_DIR/MUST_READ.md" << EOF
# 📖 必读资料 - 每日更新

*最后更新: $(date +%Y-%m-%d)*

## 🎯 当前优先级
1. 保持定时任务稳定运行
2. 持续优化自动化流程
3. 学习 Moltbook 社区最佳实践

## 📚 最近复盘
- [${YESTERDAY} 复盘](memory/reviews/review-${YESTERDAY}.md)

## 👤 用户习惯提醒
- 用户偏好直接简洁的回复
- 深夜时段活跃，避免白天打扰
- 重视实用性和自动化
- 信任执行，减少确认

## 🔄 待优化事项
$(tail -20 "$SELF_IMPROVEMENT" | grep "需要改进" -A 5 || echo "查看 SELF_IMPROVEMENT.md")

## 📊 系统状态
- GitClaw 备份: 每小时
- Moltbook 报告: 每天 00:00
- 日志清理: 每月1号
- 每日复盘: 每天 01:00

---
*每次会话前请阅读此文档*
EOF

echo "✅ 必读资料已生成"

# 6. 触发双模型讨论通知
# 发送复盘摘要到 Telegram（通过双模型讨论）
echo "📤 触发复盘讨论通知..."
/home/lchych/clawd/scripts/daily-review-notify.sh 2>/dev/null || echo "通知触发失败（将在下次会话时处理）"

echo ""
echo "=== 每日复盘完成 ==="
echo "📁 复盘报告: $REVIEW_DIR/review-${YESTERDAY}.md"
echo "📁 自我改进: $SELF_IMPROVEMENT"
echo "📁 用户画像: $USER_PROFILE"
echo "📁 必读资料: $MEMORY_DIR/MUST_READ.md"
