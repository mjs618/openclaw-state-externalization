.PHONY: help init validate stats visualize commit clean

help: ## 显示帮助信息
	@echo "OpenClaw State Externalization - 可用命令:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

init: ## 初始化新项目
	@read -p "项目名称: " name; \
	read -p "项目描述: " desc; \
	./templates/state-externalization/init-state.sh "$$name" "$$desc"

validate: ## 验证状态结构
	@./scripts/state-tools/validate.sh

stats: ## 查看统计信息
	@./scripts/state-tools/stats.sh

visualize: ## 生成可视化报告 (控制台)
	@./scripts/state-tools/visualize.py --format console

visualize-html: ## 生成可视化报告 (HTML)
	@./scripts/state-tools/visualize.py --format html --output state-report.html
	@echo "报告已生成: state-report.html"

commit: ## 提交状态变更
	@./scripts/state-tools/quick-commit.sh

commit-push: ## 提交并推送
	@./scripts/state-tools/quick-commit.sh "" --push

clean: ## 清理临时文件
	@find . -name "*.tmp" -delete
	@find . -name "*.bak" -delete
	@echo "临时文件已清理"

docs: ## 本地预览文档
	@cd docs && bundle exec jekyll serve

docs-install: ## 安装文档依赖
	@cd docs && bundle install
