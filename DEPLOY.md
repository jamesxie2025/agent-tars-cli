# 部署指南

## 📦 第一次部署到 GitHub

### 步骤 1: 提交所有文件到 GitHub

```bash
# 查看当前状态
git status

# 添加所有文件
git add .

# 提交
git commit -m "feat: initial Agent TARS CLI Docker deployment

- Add Dockerfile for Agent TARS CLI
- Add GitHub Actions workflow for auto-build
- Add docker-compose.yml for easy deployment
- Add MCP configuration (TypeScript)
- Add installation guides and scripts
"

# 推送到 GitHub
git push origin main
```

### 步骤 2: 等待 GitHub Actions 构建镜像

1. 访问 https://github.com/jamesxie2025/agent-tars-cli/actions
2. 查看 "Build and Push Docker Image" workflow
3. 等待构建完成（约 5-10 分钟）
4. 构建成功后，镜像会推送到 `ghcr.io/jamesxie2025/agent-tars-cli:latest`

### 步骤 3: 本地清理，只保留运行文件

构建成功后，本地可以删除构建相关文件：

```bash
# 删除构建相关文件
rm -f Dockerfile .dockerignore
rm -rf .github

# 删除文档文件（可选，如果不需要）
rm -f README.md INSTALL.md QUICKSTART.md DEPLOY.md

# 删除备份文件
rm -f .env.backup

# 查看保留的文件
ls -lah
```

**保留的最小文件集：**
- `.env` - 你的 API Keys 配置
- `docker-compose.yml` - 启动配置
- `mcp-config.ts` - MCP 工具配置
- `run.sh` - 快速启动脚本
- `Makefile` - 便捷命令
- `.gitignore` - Git 忽略规则
- `data/`, `cache/`, `generated/` - 数据目录

---

## 🔄 后续更新流程

### 如果需要修改 Dockerfile 或配置

1. **重新克隆仓库**（或保留一份完整副本）
2. **修改文件**
3. **提交并推送**
4. **等待 GitHub Actions 重新构建**
5. **本地拉取新镜像**

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose down
docker-compose up -d
```

---

## 📁 最小运行文件集

在任何电脑上，只需要这些文件即可运行：

```
agent-tars-cli/
├── .env                    # API Keys 配置
├── docker-compose.yml      # Docker Compose 配置
├── mcp-config.ts          # MCP 工具配置
├── run.sh                 # 启动脚本（可选）
├── Makefile               # 便捷命令（可选）
├── data/                  # 数据目录
├── cache/                 # 缓存目录
└── generated/             # 生成文件目录
```

**最小化安装（3 个文件）：**
```bash
# 只需要这 3 个文件
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/docker-compose.yml
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/mcp-config.ts
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/.env.example

# 配置
cp .env.example .env
nano .env

# 启动
docker-compose pull
docker-compose up -d
```

---

## 🚀 在新电脑上快速部署

### 方式 1: 完整克隆（推荐）

```bash
git clone https://github.com/jamesxie2025/agent-tars-cli.git
cd agent-tars-cli
cp .env.example .env
nano .env  # 填入 API Key
./run.sh
```

### 方式 2: 最小化部署

```bash
mkdir agent-tars && cd agent-tars

# 下载必要文件
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/docker-compose.yml
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/mcp-config.ts
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/.env.example

# 配置并启动
cp .env.example .env
nano .env
docker-compose pull
docker-compose up -d
```

---

## ✅ 验证部署

```bash
# 检查容器状态
docker ps | grep agent-tars

# 查看日志
docker logs -f agent-tars

# 访问 Web UI
open http://localhost:8080
```

---

## 🔧 故障排查

### 镜像拉取失败

```bash
# 检查镜像是否存在
docker pull ghcr.io/jamesxie2025/agent-tars-cli:latest

# 如果失败，检查 GitHub Actions 是否构建成功
# https://github.com/jamesxie2025/agent-tars-cli/actions
```

### 容器无法启动

```bash
# 查看详细日志
docker logs agent-tars

# 检查 .env 配置
cat .env
```

---

## 📝 注意事项

1. **首次部署后等待 GitHub Actions 构建完成**
2. **本地可以删除构建文件，但保留一份完整副本用于后续修改**
3. **`.env` 文件包含敏感信息，不要提交到 Git**
4. **定期更新镜像获取最新功能**

---

## 🎯 总结

**部署流程：**
1. 本地创建文件 → 2. Push 到 GitHub → 3. GitHub Actions 构建镜像 → 4. 本地清理 → 5. 拉取镜像运行

**运行流程：**
1. 配置 .env → 2. docker-compose pull → 3. docker-compose up -d → 4. 访问 http://localhost:8080

