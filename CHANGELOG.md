# Changelog

所有显著变更都将记录在此文件。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [Unreleased]

## [2.0.0] - 2026-03-06

### ✨ 新增

- 完整的状态外化方案实现
- 三层架构支持：大上下文模型 → Compaction → 状态外化
- 自动化初始化脚本 `init-state.sh`
- 完整的模板系统（manifest、README、active-task、Session）
- Agent 协议文档，规范 Session 启动/结束流程
- GitHub Actions CI：自动验证状态文件格式
- 自动化工具脚本（validate、stats、quick-commit）
- FAQ 文档（14+ 常见问题）
- 最佳实践指南（10 个主题）
- 跨 3 Session 完整示例

### 📝 文档

- 专业级 README（徽章、特性、快速开始）
- 架构设计文档
- 使用示例和效果对比
- 故障排查指南
- 贡献指南（CONTRIBUTING.md）

### 🔧 工具

- `validate.sh` - 状态结构验证
- `stats.sh` - Session 统计分析
- `quick-commit.sh` - 一键提交状态变更

## [1.0.0] - 2026-03-04

### ✨ 新增

- 项目初始化
- 基础模板设计
- planning-with-files 技能集成

---

## 版本说明

- **主版本号**: 不兼容的 API 变更
- **次版本号**: 向下兼容的功能新增
- **修订号**: 向下兼容的问题修复
