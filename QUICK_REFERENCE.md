# Agent TARS - 快速参考

## 📋 您的三个问题的答案

### 1️⃣ 如何访问 /app/guangzhou_weather_report.html？

**文件位置映射：**

| 容器内路径 | 本地路径 | 说明 |
|-----------|---------|------|
| `/app/data` | `./data/` | 持久化数据 |
| `/app/cache` | `./cache/` | 缓存文件 |
| `/app/generated` | `./generated/` | 生成的文件 |
| `/app/workspace` | `./workspace/` | 工作目录（新增）|

**访问方法：**

```bash
# 方法 1：从容器复制到本地（已完成）
docker cp agent-tars:/app/guangzhou_weather_report.html ./generated/

# 方法 2：在本地打开
open generated/guangzhou_weather_report.html

# 方法 3：查看所有生成的文件
ls -lh generated/
```

**当前已复制的文件：**
- ✅ `generated/guangzhou_weather_report.html`
- ✅ `generated/guangzhou_weather_chart.png`
- ✅ `generated/sales_chart.png`

---

### 2️⃣ 如何清理 data 目录中越来越多的文件？

**使用清理脚本（推荐）：**

```bash
# 运行交互式清理工具
./cleanup.sh
```

**清理选项：**
1. 清理缓存目录 (cache/)
2. 清理生成文件 (generated/)
3. 清理工作目录 (workspace/)
4. 清理所有临时文件
5. 清理 7 天前的文件
6. 清理 30 天前的文件
7. 查看大文件 (>10MB)
8. 自定义清理

**手动清理命令：**

```bash
# 清理缓存
rm -rf cache/*

# 清理生成文件
rm -rf generated/*

# 清理 7 天前的文件
find generated/ -type f -mtime +7 -delete
find workspace/ -type f -mtime +7 -delete

# 查看磁盘使用
du -sh data/ cache/ generated/ workspace/

# 查找大文件
find . -type f -size +10M -exec ls -lh {} \;
```

**定期清理建议：**
- **每周**：清理缓存和 7 天前的临时文件
- **每月**：清理 30 天前的所有文件
- **重要文件**：移动到 `archive/` 目录保存

---

### 3️⃣ 添加浏览器、Excel 和 Chart 功能

**✅ 已完成！新镜像包含：**

#### **浏览器功能**
- ✅ Chromium 已内置
- ✅ Puppeteer 支持
- ✅ 可以自动化浏览器操作

#### **Excel 功能**
- ✅ Python openpyxl（读写 .xlsx）
- ✅ Python xlrd（读取 .xls）
- ✅ Python pandas（数据处理）

#### **Chart 功能**
- ✅ Python matplotlib（静态图表）
- ✅ Python seaborn（统计图表）
- ✅ Python plotly（交互式图表）
- ✅ Node.js Chart.js（通过 MCP）

#### **数据分析**
- ✅ Python pandas（数据处理）
- ✅ Python numpy（数值计算）

---

## 🚀 更新到新版本

### 步骤 1：推送代码到 GitHub

```bash
# 如果之前推送失败，重新推送
git push origin main
```

### 步骤 2：等待 GitHub Actions 构建

访问：https://github.com/jamesxie2025/agent-tars-cli/actions

等待构建完成（约 8-12 分钟）

### 步骤 3：拉取新镜像并重启

```bash
# 停止当前容器
docker-compose down

# 拉取最新镜像
docker-compose pull

# 启动新容器
docker-compose up -d

# 查看日志
docker logs agent-tars
```

### 步骤 4：验证新功能

```bash
# 检查 Python 是否安装
docker exec agent-tars python3 --version

# 检查 Python 库
docker exec agent-tars python3 -c "import pandas, matplotlib, openpyxl; print('All libraries installed!')"

# 检查浏览器
docker exec agent-tars chromium --version

# 查看工作目录
ls -lh workspace/
```

---

## 📁 目录结构（更新后）

```
agent-tars-cli/
├── .env                      # 环境变量配置
├── .env.example              # 环境变量模板
├── docker-compose.yml        # Docker Compose 配置
├── Dockerfile                # Docker 镜像构建文件
├── cleanup.sh                # 🆕 文件清理脚本
├── mcp-config.ts             # MCP 工具配置
├── mcp-config.minimal.ts     # MCP 精简配置
│
├── 📖 文档
│   ├── README.md                 # 项目概览
│   ├── DEPLOYMENT_GUIDE.md       # 部署指南
│   ├── CONFIGURATION.md          # 配置指南
│   ├── DOCKER_CLEANUP.md         # Docker 清理指南
│   ├── FILE_ACCESS_GUIDE.md      # 🆕 文件访问指南
│   └── QUICK_REFERENCE.md        # 🆕 快速参考（本文件）
│
└── 📁 数据目录（映射到容器）
    ├── data/                 # 持久化数据
    ├── cache/                # 缓存文件
    ├── generated/            # 生成的文件
    └── workspace/            # 🆕 工作目录
```

---

## 🎯 使用示例

### 示例 1：生成 Excel 报告

在 Agent TARS Web 界面中：

```
请使用 Python pandas 创建一个销售数据的 Excel 报告，
包含以下列：日期、产品、销量、金额。
保存到 /app/workspace/sales_report.xlsx
```

查看结果：
```bash
ls -lh workspace/sales_report.xlsx
open workspace/sales_report.xlsx
```

### 示例 2：生成数据可视化图表

```
请使用 matplotlib 创建一个销售趋势图，
保存为 PNG 格式到 /app/generated/sales_trend.png
```

查看结果：
```bash
open generated/sales_trend.png
```

### 示例 3：浏览器自动化

```
请使用浏览器访问 https://www.example.com，
截图并保存到 /app/workspace/screenshot.png
```

### 示例 4：数据分析

```
请分析 /app/data/sales.csv 文件，
生成统计报告并保存为 HTML 格式到 /app/generated/analysis.html
```

---

## 🔧 常用命令速查

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看日志
docker logs -f agent-tars

# 查看容器状态
docker-compose ps

# 更新镜像
docker-compose pull && docker-compose up -d

# 进入容器
docker exec -it agent-tars sh

# 清理文件
./cleanup.sh

# 查看生成的文件
ls -lh generated/

# 打开文件
open generated/report.html

# 查看磁盘使用
du -sh data/ cache/ generated/ workspace/

# 备份文件
tar -czf backup_$(date +%Y%m%d).tar.gz generated/ workspace/
```

---

## 📚 完整文档索引

| 文档 | 内容 |
|------|------|
| [README.md](README.md) | 项目概览和快速开始 |
| [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) | 完整部署指南（适用于任何 Mac） |
| [CONFIGURATION.md](CONFIGURATION.md) | 模型配置和 API 设置 |
| [DOCKER_CLEANUP.md](DOCKER_CLEANUP.md) | Docker 镜像清理指南 |
| [FILE_ACCESS_GUIDE.md](FILE_ACCESS_GUIDE.md) | 文件访问和管理详细指南 |
| [QUICK_REFERENCE.md](QUICK_REFERENCE.md) | 快速参考（本文件） |

---

## ✅ 检查清单

更新后验证：
- [ ] 新镜像已构建完成
- [ ] 容器已更新并运行
- [ ] Python3 可用
- [ ] pandas, matplotlib, openpyxl 已安装
- [ ] Chromium 浏览器可用
- [ ] workspace 目录已映射
- [ ] 可以访问生成的文件
- [ ] 清理脚本可执行

---

**需要帮助？** 查看 [FILE_ACCESS_GUIDE.md](FILE_ACCESS_GUIDE.md) 获取详细说明。

