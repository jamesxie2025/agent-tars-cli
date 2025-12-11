# Agent TARS - 文件访问指南

## 📁 文件位置映射

Agent TARS 在容器内生成的文件会自动同步到本地目录：

| 容器内路径 | 本地路径 | 用途 |
|-----------|---------|------|
| `/app/data` | `./data/` | 持久化数据存储 |
| `/app/cache` | `./cache/` | 临时缓存文件 |
| `/app/generated` | `./generated/` | 生成的报告、图表、文档 |
| `/app/workspace` | `./workspace/` | Agent TARS 工作目录 |

## 🔍 如何访问生成的文件

### 方法 1：直接在本地目录查看（推荐）

```bash
# 查看所有生成的文件
ls -lh generated/

# 查看工作目录
ls -lh workspace/

# 打开 HTML 文件
open generated/guangzhou_weather_report.html

# 查看图片
open generated/guangzhou_weather_chart.png
```

### 方法 2：使用 Finder（Mac）

1. 打开 Finder
2. 导航到项目目录：`/Users/jamesxie/Public/agent-tars-cli`
3. 进入 `generated/` 或 `workspace/` 文件夹
4. 双击文件即可打开

### 方法 3：从容器内复制文件

```bash
# 复制单个文件
docker cp agent-tars:/app/file.html ./generated/

# 复制整个目录
docker cp agent-tars:/app/workspace/. ./workspace/

# 查看容器内的文件
docker exec agent-tars ls -lh /app/
```

### 方法 4：进入容器查看

```bash
# 进入容器
docker exec -it agent-tars sh

# 查看文件
ls -lh /app/
cd /app/workspace
ls -lh

# 退出容器
exit
```

## 📊 文件类型说明

### HTML 文件
- **位置**: `generated/*.html` 或 `workspace/*.html`
- **打开方式**: 双击或使用浏览器打开
- **用途**: 可视化报告、数据展示、交互式图表

```bash
# Mac 上打开 HTML 文件
open generated/guangzhou_weather_report.html

# 或使用特定浏览器
open -a "Google Chrome" generated/report.html
```

### 图片文件 (PNG, JPG)
- **位置**: `generated/*.png`, `generated/*.jpg`
- **打开方式**: 双击或使用图片查看器
- **用途**: 图表、截图、可视化结果

```bash
# 查看图片
open generated/guangzhou_weather_chart.png
```

### Excel 文件 (XLSX, CSV)
- **位置**: `generated/*.xlsx`, `data/*.csv`
- **打开方式**: Excel、Numbers、Google Sheets
- **用途**: 数据表格、统计结果

```bash
# 打开 Excel 文件
open generated/data.xlsx

# 查看 CSV 文件
cat data/results.csv
```

### Markdown 文件 (MD)
- **位置**: `generated/*.md`, `workspace/*.md`
- **打开方式**: 文本编辑器、Markdown 查看器
- **用途**: 文档、报告、笔记

```bash
# 查看 Markdown 文件
cat generated/report.md

# 使用 VSCode 打开
code generated/report.md
```

## 🧹 文件清理

### 自动清理脚本

使用提供的清理脚本：

```bash
# 运行清理工具
./cleanup.sh
```

清理选项：
1. 清理缓存目录 (cache/)
2. 清理生成文件 (generated/)
3. 清理工作目录 (workspace/)
4. 清理所有临时文件
5. 清理 7 天前的文件
6. 清理 30 天前的文件
7. 查看大文件 (>10MB)
8. 自定义清理

### 手动清理

```bash
# 清理缓存
rm -rf cache/*

# 清理生成文件
rm -rf generated/*

# 清理工作目录
rm -rf workspace/*

# 清理 7 天前的文件
find generated/ -type f -mtime +7 -delete
find workspace/ -type f -mtime +7 -delete

# 查看大文件
find . -type f -size +10M -exec ls -lh {} \;
```

### 定期清理建议

**每周清理：**
```bash
# 清理缓存
rm -rf cache/*

# 清理 7 天前的临时文件
find generated/ -type f -mtime +7 -delete
```

**每月清理：**
```bash
# 清理 30 天前的文件
find generated/ -type f -mtime +30 -delete
find workspace/ -type f -mtime +30 -delete
```

**保留重要文件：**
```bash
# 创建归档目录
mkdir -p archive

# 移动重要文件到归档
mv generated/important_report.html archive/
mv workspace/project_data.xlsx archive/
```

## 📈 磁盘空间监控

### 查看目录大小

```bash
# 查看所有目录大小
du -sh data/ cache/ generated/ workspace/

# 详细查看
du -h data/ | sort -h
du -h generated/ | sort -h
```

### 查找大文件

```bash
# 查找大于 10MB 的文件
find . -type f -size +10M -exec ls -lh {} \;

# 查找大于 100MB 的文件
find . -type f -size +100M -exec ls -lh {} \;

# 按大小排序显示前 10 个文件
find . -type f -exec du -h {} \; | sort -rh | head -10
```

## 🔄 文件同步

### 实时同步

Docker 卷映射是实时的，容器内的文件变化会立即反映到本地：

```bash
# 监控文件变化（Mac）
fswatch -o generated/ | xargs -n1 -I{} echo "Files changed in generated/"

# 或使用 watch 命令
watch -n 2 'ls -lh generated/'
```

### 备份文件

```bash
# 备份所有生成的文件
tar -czf backup_$(date +%Y%m%d).tar.gz data/ generated/ workspace/

# 备份到其他位置
cp -r generated/ ~/Backups/agent-tars-$(date +%Y%m%d)/

# 使用 rsync 同步
rsync -av generated/ ~/Backups/agent-tars/
```

## 🚀 快捷命令

创建别名以便快速访问：

```bash
# 添加到 ~/.bashrc 或 ~/.zshrc
alias tars-files='cd /Users/jamesxie/Public/agent-tars-cli && ls -lh generated/'
alias tars-open='open /Users/jamesxie/Public/agent-tars-cli/generated/'
alias tars-clean='cd /Users/jamesxie/Public/agent-tars-cli && ./cleanup.sh'
alias tars-backup='cd /Users/jamesxie/Public/agent-tars-cli && tar -czf ~/backup_$(date +%Y%m%d).tar.gz generated/'
```

使用：
```bash
# 查看文件
tars-files

# 打开文件夹
tars-open

# 清理文件
tars-clean

# 备份文件
tars-backup
```

## ❓ 常见问题

### Q: 为什么容器内的文件在本地看不到？

**A:** 检查 docker-compose.yml 中的卷映射是否正确：

```yaml
volumes:
  - ./data:/app/data
  - ./cache:/app/cache
  - ./generated:/app/generated
  - ./workspace:/app/workspace
```

重启容器：
```bash
docker-compose down
docker-compose up -d
```

### Q: 如何让 Agent TARS 将文件保存到特定目录？

**A:** 在与 Agent TARS 对话时，明确指定路径：

```
请将报告保存到 /app/generated/report.html
请将图表保存到 /app/workspace/chart.png
```

### Q: 文件太多了，如何批量删除？

**A:** 使用清理脚本或手动删除：

```bash
# 使用清理脚本（推荐）
./cleanup.sh

# 手动删除所有 HTML 文件
rm generated/*.html

# 删除 7 天前的所有文件
find generated/ -type f -mtime +7 -delete
```

### Q: 如何在浏览器中直接打开生成的 HTML 文件？

**A:** 使用 `open` 命令或拖拽到浏览器：

```bash
# Mac
open generated/report.html

# 使用特定浏览器
open -a "Google Chrome" generated/report.html

# 或直接拖拽文件到浏览器窗口
```

---

## 📚 相关文档

- [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - 部署指南
- [CONFIGURATION.md](CONFIGURATION.md) - 配置指南
- [DOCKER_CLEANUP.md](DOCKER_CLEANUP.md) - Docker 清理指南
- [README.md](README.md) - 项目概览

