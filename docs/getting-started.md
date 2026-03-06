# 快速开始

## 安装

### 方式 1: 克隆仓库

```bash
git clone https://github.com/mjs618/openclaw-state-externalization.git
cd openclaw-state-externalization
```

### 方式 2: 复制到你的项目

```bash
# 复制模板目录
cp -r openclaw-state-externalization/templates/state-externalization/* your-project/

# 初始化状态
mkdir -p state/{sessions,decisions,context}
```

## 初始化项目

### 使用脚本（推荐）

```bash
./templates/state-externalization/init-state.sh "项目名称" "项目描述"
```

### 手动初始化

1. 复制模板文件到 `state/` 目录
2. 填充变量（`{{PROJECT_NAME}}` 等）
3. 创建首条 Session 记录

## 验证安装

```bash
# 验证状态结构
./scripts/state-tools/validate.sh

# 查看统计
./scripts/state-tools/stats.sh

# 生成可视化报告
./scripts/state-tools/visualize.py
```

## 下一步

- [核心概念](concepts.md) - 了解状态外化的工作原理
- [使用指南](usage-guide.md) - 详细的使用说明
- [示例](examples.md) - 完整的工作流程示例
