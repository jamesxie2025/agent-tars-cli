#!/bin/bash

# Agent TARS - 更新脚本
# 自动拉取最新镜像并重启容器

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Agent TARS - 更新到最新版本${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 步骤 1: 停止当前容器
echo -e "${YELLOW}步骤 1/4: 停止当前容器...${NC}"
docker-compose down
echo -e "${GREEN}✅ 容器已停止${NC}"
echo ""

# 步骤 2: 拉取最新镜像
echo -e "${YELLOW}步骤 2/4: 拉取最新镜像...${NC}"
echo -e "${BLUE}这可能需要几分钟，请耐心等待...${NC}"
docker-compose pull
echo -e "${GREEN}✅ 镜像已更新${NC}"
echo ""

# 步骤 3: 启动新容器
echo -e "${YELLOW}步骤 3/4: 启动新容器...${NC}"
docker-compose up -d
echo -e "${GREEN}✅ 容器已启动${NC}"
echo ""

# 步骤 4: 等待容器就绪
echo -e "${YELLOW}步骤 4/4: 等待容器就绪...${NC}"
sleep 15
echo -e "${GREEN}✅ 容器已就绪${NC}"
echo ""

# 显示容器状态
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  容器状态${NC}"
echo -e "${BLUE}=========================================${NC}"
docker ps | grep agent-tars
echo ""

# 显示日志
echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  最近日志${NC}"
echo -e "${BLUE}=========================================${NC}"
docker logs agent-tars 2>&1 | tail -20
echo ""

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  ✅ 更新完成！${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo -e "访问 Agent TARS: ${BLUE}http://localhost:8080${NC}"
echo ""

