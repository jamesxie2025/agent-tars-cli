#!/bin/bash

# Agent TARS CLI - 部署到 GitHub 脚本

set -e

echo "========================================="
echo "Agent TARS CLI - 部署到 GitHub"
echo "========================================="
echo ""

# 检查 Git 状态
if [ ! -d .git ]; then
    echo "❌ 错误: 不是 Git 仓库"
    exit 1
fi

# 显示当前状态
echo "📋 当前文件状态:"
git status --short
echo ""

# 确认
read -p "是否要提交所有文件到 GitHub? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 取消部署"
    exit 1
fi

# 添加所有文件
echo "📦 添加文件到 Git..."
git add .

# 提交
echo "💾 提交更改..."
git commit -m "feat: initial Agent TARS CLI Docker deployment

- Add Dockerfile for @agent-tars/cli
- Add GitHub Actions workflow for auto-build
- Add docker-compose.yml for easy deployment
- Add MCP configuration (TypeScript)
- Add installation guides and scripts
- Support multiple AI providers (ModelScope, DeepSeek, OpenAI, etc.)
"

# 推送
echo "🚀 推送到 GitHub..."
git push origin main

echo ""
echo "========================================="
echo "✅ 成功推送到 GitHub！"
echo "========================================="
echo ""
echo "📍 下一步:"
echo "  1. 访问 https://github.com/jamesxie2025/agent-tars-cli/actions"
echo "  2. 等待 GitHub Actions 构建完成（约 5-10 分钟）"
echo "  3. 构建成功后，运行 ./cleanup-local.sh 清理本地文件"
echo ""

