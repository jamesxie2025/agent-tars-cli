#!/bin/bash

# Agent TARS CLI - 快速启动脚本
# 从 GitHub 拉取镜像并运行

set -e

echo "========================================="
echo "Agent TARS CLI - 快速启动"
echo "========================================="
echo ""

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ 错误: Docker 未安装"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查 .env 文件
if [ ! -f .env ]; then
    echo "⚠️  警告: .env 文件不存在"
    echo "正在从 .env.example 创建 .env..."
    cp .env.example .env
    echo ""
    echo "✓ 已创建 .env 文件"
    echo "请编辑 .env 文件，填入你的 API Key，然后重新运行此脚本"
    echo ""
    echo "编辑命令: nano .env"
    exit 1
fi

# 创建必要的目录
echo "📁 创建数据目录..."
mkdir -p data cache generated
echo "✓ 目录创建完成"
echo ""

# 拉取最新镜像
echo "📦 拉取最新 Docker 镜像..."
docker pull ghcr.io/jamesxie2025/agent-tars-cli:latest
echo "✓ 镜像拉取完成"
echo ""

# 停止旧容器（如果存在）
if docker ps -a | grep -q agent-tars; then
    echo "🛑 停止旧容器..."
    docker stop agent-tars 2>/dev/null || true
    docker rm agent-tars 2>/dev/null || true
    echo "✓ 旧容器已清理"
    echo ""
fi

# 启动容器
echo "🚀 启动 Agent TARS..."
docker run -d \
  --name agent-tars \
  --restart unless-stopped \
  -p 8080:8080 \
  -v "$(pwd)/data:/app/data" \
  -v "$(pwd)/cache:/app/cache" \
  -v "$(pwd)/generated:/app/generated" \
  -v "$(pwd)/mcp-config.ts:/app/mcp-config.ts:ro" \
  --env-file .env \
  ghcr.io/jamesxie2025/agent-tars-cli:latest

echo ""
echo "========================================="
echo "✅ Agent TARS 启动成功！"
echo "========================================="
echo ""
echo "📍 访问地址: http://localhost:8080"
echo ""
echo "常用命令:"
echo "  查看日志: docker logs -f agent-tars"
echo "  停止服务: docker stop agent-tars"
echo "  重启服务: docker restart agent-tars"
echo ""

