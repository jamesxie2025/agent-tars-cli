.PHONY: help pull start stop restart logs shell clean update

help: ## 显示帮助信息
	@echo "Agent TARS CLI - 可用命令:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

pull: ## 拉取最新镜像
	@echo "📦 拉取最新镜像..."
	@docker-compose pull

start: ## 启动服务
	@echo "🚀 启动 Agent TARS..."
	@docker-compose up -d
	@echo "✅ 服务已启动"
	@echo "📍 访问: http://localhost:8080"

stop: ## 停止服务
	@echo "🛑 停止服务..."
	@docker-compose down
	@echo "✅ 服务已停止"

restart: ## 重启服务
	@echo "🔄 重启服务..."
	@docker-compose restart
	@echo "✅ 服务已重启"

logs: ## 查看日志
	@docker-compose logs -f

shell: ## 进入容器
	@docker-compose exec agent-tars sh

clean: ## 清理容器和镜像
	@echo "🧹 清理容器..."
	@docker-compose down
	@docker rmi ghcr.io/jamesxie2025/agent-tars-cli:latest || true
	@echo "✅ 清理完成"

update: pull ## 更新到最新版本
	@echo "🔄 更新服务..."
	@docker-compose down
	@docker-compose up -d
	@echo "✅ 更新完成"

status: ## 查看状态
	@docker-compose ps

quick-start: pull start ## 快速启动（拉取+启动）
	@echo ""
	@echo "========================================="
	@echo "✅ Agent TARS 已启动！"
	@echo "========================================="
	@echo "📍 访问: http://localhost:8080"
	@echo ""

