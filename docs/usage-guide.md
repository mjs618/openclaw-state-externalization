# 使用指南

## 初始化新项目

### 使用脚本

```bash
./templates/state-externalization/init-state.sh \
  "电商 API 项目" \
  "设计并实现电商系统 REST API"
```

这会创建：
- `state/manifest.json` - 全局状态
- `state/README.md` - 项目概览
- `state/active-task.md` - 当前任务
- `state/sessions/YYYY-MM-DD-001.md` - 首条 Session
- `task_plan.md`, `findings.md`, `progress.md` - Planning 文件

### 手动初始化

```bash
# 1. 创建目录结构
mkdir -p state/{sessions,decisions,context}

# 2. 复制模板
cp templates/state-externalization/manifest.json state/
cp templates/state-externalization/README.md state/
cp templates/state-externalization/active-task.md state/

# 3. 填充变量
sed -i 's/{{PROJECT_NAME}}/我的项目/g' state/*.json state/*.md
```

## 日常 workflow

### 启动 Session

**Agent 自动执行：**

```bash
# 读取状态
jq . state/manifest.json
cat state/active-task.md
cat state/sessions/$(ls state/sessions | sort | tail -1)
```

**人类手动执行：**

```bash
# 拉取最新状态
git pull

# 验证状态
./scripts/state-tools/validate.sh
```

### 执行工作

1. 按照 `active-task.md` 的待办清单工作
2. 遇到重要发现及时更新 `findings.md`
3. 遇到问题记录在 Session 文件

### 结束 Session

**Agent 自动执行：**

```
1. 更新 task_plan.md
2. 追加 findings.md
3. 追加 progress.md
4. 创建 sessions/YYYY-MM-DD-XXX.md
5. 更新 active-task.md
6. 更新 manifest.json
```

**人类手动执行：**

```bash
# 快速提交
./scripts/state-tools/quick-commit.sh "Session 003: 完成用户模块"

# 或手动提交
git add state/ task_plan.md findings.md progress.md
git commit -m "Session 003: 完成用户模块"
git push
```

## 工具脚本使用

### validate.sh - 验证状态

```bash
./scripts/state-tools/validate.sh

# 输出：
# 🔍 验证状态外化结构...
# ========================
# 📁 检查必要文件...
#   ✅ manifest.json
#   ✅ README.md
#   ✅ active-task.md
#   ✅ task-tree.md
```

### stats.sh - 统计信息

```bash
./scripts/state-tools/stats.sh

# 输出：
# 📊 Session 统计报告
# ====================
# 📈 基本统计
# 总 Session 数: 5
# ...
```

### visualize.py - 可视化

```bash
# 控制台报告
./scripts/state-tools/visualize.py --format console

# HTML 报告
./scripts/state-tools/visualize.py --format html --output report.html
```

## 多人协作

### 分支策略

```bash
# main 分支 - 稳定状态
git checkout main
git pull

# 功能分支
git checkout -b feature/auth-module
# ... 工作 ...
git push origin feature/auth-module
# PR 合并
```

### 冲突解决

**manifest.json 冲突：**

```bash
# 手动合并，保留最新状态
# 或使用工具
npm install -g json-diff
json-diff state/manifest.json state/manifest.json.back
```

### 任务分配

在 `state/task-tree.md` 中明确标注：

```markdown
- task-001: 用户模块 [进行中] @agent-a
- task-002: 商品模块 [待开始] @agent-b
- task-003: 订单模块 [待开始] @human
```

## 故障排查

### Agent 没有读取状态

检查：
1. 文件路径正确
2. 文件存在
3. Agent 有 Read 权限

### Session 记录未创建

检查：
1. `state/sessions` 目录存在
2. 有写权限

### Git 冲突频繁

解决：
1. 更频繁地 commit/push
2. 任务拆分更细
3. 使用 feature 分支
