#!/bin/bash

# Agent TARS - 文件清理脚本
# 用于清理生成的文件和释放磁盘空间

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE}  Agent TARS - 文件清理工具${NC}"
echo -e "${BLUE}=========================================${NC}"
echo ""

# 显示当前磁盘使用情况
show_disk_usage() {
    echo -e "${YELLOW}📊 当前磁盘使用情况：${NC}"
    echo ""
    
    if [ -d "data" ]; then
        DATA_SIZE=$(du -sh data 2>/dev/null | cut -f1)
        echo -e "  📁 data/      : ${DATA_SIZE}"
    fi
    
    if [ -d "cache" ]; then
        CACHE_SIZE=$(du -sh cache 2>/dev/null | cut -f1)
        echo -e "  📁 cache/     : ${CACHE_SIZE}"
    fi
    
    if [ -d "generated" ]; then
        GEN_SIZE=$(du -sh generated 2>/dev/null | cut -f1)
        echo -e "  📁 generated/ : ${GEN_SIZE}"
    fi
    
    if [ -d "workspace" ]; then
        WORK_SIZE=$(du -sh workspace 2>/dev/null | cut -f1)
        echo -e "  📁 workspace/ : ${WORK_SIZE}"
    fi
    
    echo ""
}

# 清理选项菜单
show_menu() {
    echo -e "${GREEN}请选择清理选项：${NC}"
    echo ""
    echo "  1) 清理缓存目录 (cache/)"
    echo "  2) 清理生成文件 (generated/)"
    echo "  3) 清理工作目录 (workspace/)"
    echo "  4) 清理所有临时文件"
    echo "  5) 清理 7 天前的文件"
    echo "  6) 清理 30 天前的文件"
    echo "  7) 查看大文件 (>10MB)"
    echo "  8) 自定义清理"
    echo "  0) 退出"
    echo ""
}

# 清理缓存
clean_cache() {
    echo -e "${YELLOW}🧹 清理缓存目录...${NC}"
    if [ -d "cache" ]; then
        rm -rf cache/*
        echo -e "${GREEN}✅ 缓存已清理${NC}"
    else
        echo -e "${RED}❌ cache/ 目录不存在${NC}"
    fi
}

# 清理生成文件
clean_generated() {
    echo -e "${YELLOW}🧹 清理生成文件...${NC}"
    if [ -d "generated" ]; then
        rm -rf generated/*
        echo -e "${GREEN}✅ 生成文件已清理${NC}"
    else
        echo -e "${RED}❌ generated/ 目录不存在${NC}"
    fi
}

# 清理工作目录
clean_workspace() {
    echo -e "${YELLOW}🧹 清理工作目录...${NC}"
    if [ -d "workspace" ]; then
        rm -rf workspace/*
        echo -e "${GREEN}✅ 工作目录已清理${NC}"
    else
        echo -e "${RED}❌ workspace/ 目录不存在${NC}"
    fi
}

# 清理所有临时文件
clean_all_temp() {
    echo -e "${YELLOW}🧹 清理所有临时文件...${NC}"
    clean_cache
    clean_generated
    clean_workspace
    echo -e "${GREEN}✅ 所有临时文件已清理${NC}"
}

# 清理 N 天前的文件
clean_old_files() {
    local days=$1
    echo -e "${YELLOW}🧹 清理 ${days} 天前的文件...${NC}"
    
    local count=0
    for dir in data generated workspace; do
        if [ -d "$dir" ]; then
            echo -e "  检查 ${dir}/ ..."
            local found=$(find "$dir" -type f -mtime +${days} 2>/dev/null | wc -l)
            if [ $found -gt 0 ]; then
                find "$dir" -type f -mtime +${days} -delete 2>/dev/null
                count=$((count + found))
            fi
        fi
    done
    
    echo -e "${GREEN}✅ 已删除 ${count} 个文件${NC}"
}

# 查看大文件
show_large_files() {
    echo -e "${YELLOW}📊 查找大于 10MB 的文件...${NC}"
    echo ""
    
    for dir in data cache generated workspace; do
        if [ -d "$dir" ]; then
            find "$dir" -type f -size +10M -exec ls -lh {} \; 2>/dev/null | \
                awk '{print $9 " (" $5 ")"}'
        fi
    done
    
    echo ""
}

# 主程序
main() {
    show_disk_usage
    
    while true; do
        show_menu
        read -p "请输入选项 [0-8]: " choice
        echo ""
        
        case $choice in
            1)
                clean_cache
                ;;
            2)
                clean_generated
                ;;
            3)
                clean_workspace
                ;;
            4)
                read -p "确认清理所有临时文件？(y/N): " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    clean_all_temp
                fi
                ;;
            5)
                clean_old_files 7
                ;;
            6)
                clean_old_files 30
                ;;
            7)
                show_large_files
                ;;
            8)
                read -p "输入天数（删除 N 天前的文件）: " days
                if [[ "$days" =~ ^[0-9]+$ ]]; then
                    clean_old_files $days
                else
                    echo -e "${RED}❌ 无效输入${NC}"
                fi
                ;;
            0)
                echo -e "${GREEN}👋 再见！${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ 无效选项${NC}"
                ;;
        esac
        
        echo ""
        show_disk_usage
    done
}

# 运行主程序
main

