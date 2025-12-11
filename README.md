# Agent TARS CLI - Docker 部署

基于字节跳动 Agent TARS 的 Docker 镜像部署方案。

## 🚀 快速开始（从 GitHub 拉取镜像）

### 前置要求

- Docker 和 Docker Compose 已安装
- 至少一个 AI 模型的 API Key

### 步骤 1: 克隆配置文件

```bash
git clone https://github.com/jamesxie2025/agent-tars-cli.git
cd agent-tars-cli
```

### 步骤 2: 配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑 .env 文件，填入你的 API Key
nano .env
```

**至少配置一个模型提供商：**

```env
# 选择一个配置
ANTHROPIC_API_KEY=your_key_here
# 或
OPENAI_API_KEY=your_key_here
# 或
DEEPSEEK_API_KEY=your_key_here
# 或
MODELSCOPE_API_KEY=your_key_here
```

### 步骤 3: 启动服务

```bash
# 拉取最新镜像并启动
docker-compose pull
docker-compose up -d

# 查看日志
docker-compose logs -f
```

### 步骤 4: 访问 Web UI

打开浏览器访问：`http://localhost:8080`

---

## 📦 使用预构建镜像

### 方式一：Docker Compose（推荐）

```bash
docker-compose up -d
```

### 方式二：直接使用 Docker

```bash
# 拉取镜像
docker pull ghcr.io/jamesxie2025/agent-tars-cli:latest

# 运行容器
docker run -d \
  --name agent-tars \
  -p 8080:8080 \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/cache:/app/cache \
  -v $(pwd)/generated:/app/generated \
  -v $(pwd)/mcp-config.ts:/app/mcp-config.ts:ro \
  --env-file .env \
  ghcr.io/jamesxie2025/agent-tars-cli:latest
```

---

## 🔧 配置说明

### 支持的模型提供商

| 提供商 | 环境变量 | 获取地址 |
|--------|----------|----------|
| Anthropic (Claude) | `ANTHROPIC_API_KEY` | https://console.anthropic.com/settings/keys |
| OpenAI | `OPENAI_API_KEY` | https://platform.openai.com/api-keys |
| DeepSeek | `DEEPSEEK_API_KEY` | https://platform.deepseek.com/api_keys |
| ModelScope (Qwen) | `MODELSCOPE_API_KEY` | https://modelscope.cn/my/myaccesstoken |
| VolcEngine (豆包) | `VOLCENGINE_API_KEY` | https://console.volcengine.com/ark/region:ark+cn-beijing/apiKey |

### MCP 工具配置

编辑 `mcp-config.ts` 来启用/禁用 MCP 工具。

**完整版配置** (`mcp-config.ts`)：
- **filesystem**: 文件操作
- **excel**: Excel 文件处理
- **chart**: 图表生成
- **memory**: 持久化记忆
- **git**: Git 操作
- **sqlite**: 本地数据库

**精简版配置** (`mcp-config.minimal.ts`)：
- **filesystem**: 文件操作
- **memory**: 持久化记忆
- **git**: Git 操作
- **sqlite**: 本地数据库

如果遇到工具加载问题，可以使用精简版：
```bash
# 备份原配置
mv mcp-config.ts mcp-config.ts.backup

# 使用精简版
cp mcp-config.minimal.ts mcp-config.ts

# 重启容器
docker-compose restart
```

可选工具（需要配置 API Key）：
- **brave-search**: 网络搜索
- **github**: GitHub 集成
- **postgres**: PostgreSQL 数据库

---

## 📁 目录结构

```
agent-tars-cli/
├── .env                      # 环境变量（不提交到 Git）
├── .env.example              # 环境变量模板
├── docker-compose.yml        # Docker Compose 配置
├── Dockerfile                # Docker 镜像构建文件
├── mcp-config.ts             # MCP 工具配置（完整版）
├── mcp-config.minimal.ts     # MCP 工具配置（精简版）
├── DEPLOYMENT_GUIDE.md       # 📖 详细部署指南
├── CONFIGURATION.md          # 📖 模型配置指南
├── DOCKER_CLEANUP.md         # 📖 Docker 清理指南
├── data/                     # 数据目录（持久化）
├── cache/                    # 缓存目录（持久化）
└── generated/                # 生成文件目录（持久化）
```

---

## 📖 文档索引

- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - 完整的部署指南，适用于任何 Mac 电脑
- **[CONFIGURATION.md](CONFIGURATION.md)** - 如何更换 AI 模型和配置 API
- **[DOCKER_CLEANUP.md](DOCKER_CLEANUP.md)** - 如何清理 Docker 镜像和释放空间

---

## 🛠️ 常用命令

```bash
# 启动服务
docker-compose up -d

# 停止服务
docker-compose down

# 查看日志
docker-compose logs -f

# 重启服务
docker-compose restart

# 更新到最新镜像
docker-compose pull
docker-compose up -d

# 进入容器
docker-compose exec agent-tars sh
```

---

## 🔄 更新镜像

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose down
docker-compose up -d
```

---

## ❓ 常见问题

### 1. 端口被占用

修改 `.env` 文件中的 `PORT` 变量：

```env
PORT=8081
```

### 2. 镜像拉取失败

检查网络连接，或使用镜像加速器。

### 3. 容器无法启动

检查 `.env` 文件是否正确配置了 API Key：

```bash
docker-compose logs
```

---

## 📝 License

Apache 2.0

---

## 🔗 相关链接

- [Agent TARS 官网](https://agent-tars.com)
- [Agent TARS GitHub](https://github.com/bytedance/UI-TARS-desktop)
- [Agent TARS 文档](https://agent-tars.com/guide/get-started/quick-start.html)

