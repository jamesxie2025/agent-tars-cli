#!/bin/bash

# Agent TARS - 诊断脚本
# 检查浏览器、Python、Excel、Chart 等功能是否正常

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Agent TARS - 功能诊断工具${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 检查容器是否运行
echo -e "${YELLOW}📦 检查容器状态...${NC}"
if docker ps | grep -q agent-tars; then
    echo -e "${GREEN}✅ 容器正在运行${NC}"
else
    echo -e "${RED}❌ 容器未运行${NC}"
    echo "请先启动容器: docker-compose up -d"
    exit 1
fi
echo ""

# 检查镜像版本
echo -e "${YELLOW}🏷️  检查镜像版本...${NC}"
IMAGE_ID=$(docker inspect agent-tars --format='{{.Image}}' | cut -d: -f2 | cut -c1-12)
IMAGE_DATE=$(docker inspect agent-tars --format='{{.Created}}')
echo -e "  镜像 ID: ${IMAGE_ID}"
echo -e "  创建时间: ${IMAGE_DATE}"
echo ""

# 检查浏览器
echo -e "${YELLOW}🌐 检查浏览器...${NC}"
if docker exec agent-tars which chromium > /dev/null 2>&1; then
    CHROMIUM_VERSION=$(docker exec agent-tars chromium --version 2>&1 | head -1)
    echo -e "${GREEN}✅ Chromium: ${CHROMIUM_VERSION}${NC}"
else
    echo -e "${RED}❌ Chromium 未安装${NC}"
fi

if docker exec agent-tars which google-chrome > /dev/null 2>&1; then
    echo -e "${GREEN}✅ google-chrome 符号链接存在${NC}"
else
    echo -e "${YELLOW}⚠️  google-chrome 符号链接不存在${NC}"
fi

if docker exec agent-tars which chrome > /dev/null 2>&1; then
    echo -e "${GREEN}✅ chrome 符号链接存在${NC}"
else
    echo -e "${YELLOW}⚠️  chrome 符号链接不存在${NC}"
fi
echo ""

# 检查环境变量
echo -e "${YELLOW}🔧 检查浏览器环境变量...${NC}"
docker exec agent-tars env | grep -E "(CHROME|BROWSER|PUPPETEER)" | while read line; do
    echo -e "  ${line}"
done
echo ""

# 检查 Python
echo -e "${YELLOW}🐍 检查 Python...${NC}"
if docker exec agent-tars which python3 > /dev/null 2>&1; then
    PYTHON_VERSION=$(docker exec agent-tars python3 --version 2>&1)
    echo -e "${GREEN}✅ Python: ${PYTHON_VERSION}${NC}"
    
    # 检查 Python 库
    echo -e "${YELLOW}📚 检查 Python 库...${NC}"
    
    LIBS=("pandas" "matplotlib" "seaborn" "plotly" "openpyxl" "xlrd" "numpy")
    for lib in "${LIBS[@]}"; do
        if docker exec agent-tars python3 -c "import $lib" > /dev/null 2>&1; then
            VERSION=$(docker exec agent-tars python3 -c "import $lib; print($lib.__version__)" 2>&1)
            echo -e "${GREEN}  ✅ $lib: $VERSION${NC}"
        else
            echo -e "${RED}  ❌ $lib 未安装${NC}"
        fi
    done
else
    echo -e "${RED}❌ Python3 未安装${NC}"
fi
echo ""

# 检查 Node.js 和 npm
echo -e "${YELLOW}📦 检查 Node.js 环境...${NC}"
NODE_VERSION=$(docker exec agent-tars node --version 2>&1)
NPM_VERSION=$(docker exec agent-tars npm --version 2>&1)
echo -e "${GREEN}✅ Node.js: ${NODE_VERSION}${NC}"
echo -e "${GREEN}✅ npm: ${NPM_VERSION}${NC}"
echo ""

# 检查 MCP 配置
echo -e "${YELLOW}🔌 检查 MCP 配置...${NC}"
if docker exec agent-tars test -f /app/mcp-config.ts; then
    echo -e "${GREEN}✅ mcp-config.ts 存在${NC}"
    
    # 检查配置内容
    MCP_SERVERS=$(docker exec agent-tars grep -o "^\s*[a-z-]*:" /app/mcp-config.ts | grep -v "mcpServers:" | tr -d ' :' | grep -v "^$")
    echo -e "  配置的 MCP 服务器:"
    echo "$MCP_SERVERS" | while read server; do
        if [ ! -z "$server" ]; then
            echo -e "    - ${server}"
        fi
    done
else
    echo -e "${RED}❌ mcp-config.ts 不存在${NC}"
fi
echo ""

# 检查目录映射
echo -e "${YELLOW}📁 检查目录映射...${NC}"
DIRS=("data" "cache" "generated" "workspace")
for dir in "${DIRS[@]}"; do
    if docker exec agent-tars test -d "/app/$dir"; then
        SIZE=$(docker exec agent-tars du -sh "/app/$dir" 2>&1 | cut -f1)
        echo -e "${GREEN}  ✅ /app/$dir → ./$dir/ (${SIZE})${NC}"
    else
        echo -e "${RED}  ❌ /app/$dir 不存在${NC}"
    fi
done
echo ""

# 检查 Agent TARS 日志
echo -e "${YELLOW}📋 检查 Agent TARS 日志（最近 10 行）...${NC}"
docker logs agent-tars 2>&1 | tail -10
echo ""

# 检查错误
echo -e "${YELLOW}⚠️  检查错误日志...${NC}"
ERROR_COUNT=$(docker logs agent-tars 2>&1 | grep -i "error" | wc -l | tr -d ' ')
if [ "$ERROR_COUNT" -gt 0 ]; then
    echo -e "${RED}发现 ${ERROR_COUNT} 个错误${NC}"
    echo -e "${YELLOW}最近的错误:${NC}"
    docker logs agent-tars 2>&1 | grep -i "error" | tail -5
else
    echo -e "${GREEN}✅ 没有发现错误${NC}"
fi
echo ""

# 总结
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  诊断总结${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 生成建议
echo -e "${YELLOW}💡 建议:${NC}"
echo ""

if ! docker exec agent-tars which python3 > /dev/null 2>&1; then
    echo -e "${RED}❌ Python3 未安装${NC}"
    echo -e "   需要更新到最新镜像（Build #12）"
    echo -e "   运行: docker-compose pull && docker-compose up -d"
    echo ""
fi

if ! docker exec agent-tars which google-chrome > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  浏览器符号链接缺失${NC}"
    echo -e "   需要更新到最新镜像（Build #12）"
    echo -e "   运行: docker-compose pull && docker-compose up -d"
    echo ""
fi

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  发现错误日志${NC}"
    echo -e "   查看完整日志: docker logs agent-tars"
    echo -e "   查看实时日志: docker logs -f agent-tars"
    echo ""
fi

echo -e "${GREEN}✅ 诊断完成！${NC}"
echo ""
echo -e "查看 GitHub Actions 构建状态:"
echo -e "https://github.com/jamesxie2025/agent-tars-cli/actions"
echo ""

