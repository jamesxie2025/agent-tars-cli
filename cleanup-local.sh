#!/bin/bash

# Agent TARS CLI - 本地清理脚本
# 删除构建相关文件，只保留运行所需的最小文件

set -e

echo "========================================="
echo "Agent TARS CLI - 本地清理"
echo "========================================="
echo ""

echo "⚠️  警告: 此脚本将删除以下文件:"
echo "  - Dockerfile"
echo "  - .dockerignore"
echo "  - .github/ (GitHub Actions)"
echo "  - .env.backup"
echo "  - deploy-to-github.sh"
echo "  - cleanup-local.sh (本脚本)"
echo ""
echo "保留的文件:"
echo "  - .env (你的 API Keys)"
echo "  - docker-compose.yml"
echo "  - mcp-config.ts"
echo "  - run.sh"
echo "  - Makefile"
echo "  - README.md, INSTALL.md, QUICKSTART.md, DEPLOY.md"
echo "  - data/, cache/, generated/"
echo ""

read -p "确认清理? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 取消清理"
    exit 1
fi

echo "🧹 开始清理..."

# 删除构建相关文件
rm -f Dockerfile
rm -f .dockerignore
rm -rf .github
rm -f .env.backup

echo "✓ 已删除构建文件"

# 可选：删除文档（如果不需要）
read -p "是否也删除文档文件? (README.md, INSTALL.md 等) (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f README.md INSTALL.md QUICKSTART.md DEPLOY.md
    echo "✓ 已删除文档文件"
fi

# 删除部署脚本
rm -f deploy-to-github.sh

echo ""
echo "========================================="
echo "✅ 清理完成！"
echo "========================================="
echo ""
echo "📁 保留的文件:"
ls -lah | grep -v "^d" | grep -v "total"
echo ""
echo "📍 现在可以使用以下命令运行 Agent TARS:"
echo "  ./run.sh"
echo "  或"
echo "  make quick-start"
echo ""

# 自删除
rm -f cleanup-local.sh

