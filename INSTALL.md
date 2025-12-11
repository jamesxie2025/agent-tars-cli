# Agent TARS CLI - 安装指南

## 📋 在任何电脑上安装（从 GitHub 拉取镜像）

### 前置要求

1. **Docker** - [安装 Docker](https://docs.docker.com/get-docker/)
2. **Git** - [安装 Git](https://git-scm.com/downloads)
3. **AI 模型 API Key** - 至少一个（见下方）

---

## 🚀 安装步骤

### 步骤 1: 克隆仓库

```bash
git clone https://github.com/jamesxie2025/agent-tars-cli.git
cd agent-tars-cli
```

### 步骤 2: 配置 API Key

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑配置文件
nano .env  # 或使用你喜欢的编辑器
```

**配置至少一个模型提供商：**

```env
# 选择一个或多个
ANTHROPIC_API_KEY=sk-ant-xxxxx
OPENAI_API_KEY=sk-xxxxx
DEEPSEEK_API_KEY=sk-xxxxx
MODELSCOPE_API_KEY=ms-xxxxx
```

### 步骤 3: 启动服务

**方式 A: 使用启动脚本（推荐）**

```bash
chmod +x run.sh
./run.sh
```

**方式 B: 使用 Docker Compose**

```bash
docker-compose pull
docker-compose up -d
```

**方式 C: 使用 Docker 命令**

```bash
docker pull ghcr.io/jamesxie2025/agent-tars-cli:latest

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

### 步骤 4: 访问 Web UI

打开浏览器：`http://localhost:8080`

---

## 🔑 获取 API Keys

| 提供商 | 获取地址 | 说明 |
|--------|----------|------|
| **Anthropic** | https://console.anthropic.com/settings/keys | Claude 系列模型 |
| **OpenAI** | https://platform.openai.com/api-keys | GPT 系列模型 |
| **DeepSeek** | https://platform.deepseek.com/api_keys | DeepSeek 模型 |
| **ModelScope** | https://modelscope.cn/my/myaccesstoken | Qwen 系列模型 |
| **VolcEngine** | https://console.volcengine.com/ark/region:ark+cn-beijing/apiKey | 豆包模型 |

---

## 🖥️ 在另一台电脑上安装

### 方法 1: 完整克隆（推荐）

```bash
# 在新电脑上
git clone https://github.com/jamesxie2025/agent-tars-cli.git
cd agent-tars-cli
cp .env.example .env
# 编辑 .env 填入 API Key
./run.sh
```

### 方法 2: 最小化安装

只需要 3 个文件：

1. **docker-compose.yml**
2. **.env**（配置好的）
3. **mcp-config.ts**

```bash
# 创建目录
mkdir agent-tars && cd agent-tars

# 下载必要文件
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/docker-compose.yml
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/mcp-config.ts
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/.env.example

# 配置
cp .env.example .env
nano .env  # 填入 API Key

# 启动
docker-compose pull
docker-compose up -d
```

---

## 🔄 更新到最新版本

```bash
# 拉取最新镜像
docker-compose pull

# 重启服务
docker-compose down
docker-compose up -d
```

或使用脚本：

```bash
./run.sh
```

---

## 🛠️ 管理命令

```bash
# 查看状态
docker ps | grep agent-tars

# 查看日志
docker logs -f agent-tars

# 停止服务
docker stop agent-tars

# 启动服务
docker start agent-tars

# 重启服务
docker restart agent-tars

# 删除容器
docker rm -f agent-tars

# 进入容器
docker exec -it agent-tars sh
```

---

## ❓ 故障排查

### 问题 1: 镜像拉取失败

**解决方法：**
```bash
# 检查网络
ping ghcr.io

# 使用代理（如果需要）
export HTTP_PROXY=http://your-proxy:port
export HTTPS_PROXY=http://your-proxy:port
```

### 问题 2: 容器无法启动

**检查日志：**
```bash
docker logs agent-tars
```

**常见原因：**
- API Key 未配置或错误
- 端口 8080 被占用（修改 .env 中的 PORT）
- 权限问题（检查 data/cache/generated 目录权限）

### 问题 3: 无法访问 Web UI

**检查：**
```bash
# 确认容器运行
docker ps | grep agent-tars

# 确认端口映射
docker port agent-tars

# 测试连接
curl http://localhost:8080
```

---

## 📦 完全卸载

```bash
# 停止并删除容器
docker stop agent-tars
docker rm agent-tars

# 删除镜像
docker rmi ghcr.io/jamesxie2025/agent-tars-cli:latest

# 删除数据（可选）
rm -rf data cache generated

# 删除配置
rm .env
```

---

## 💡 提示

1. **备份 .env 文件** - 包含你的 API Keys
2. **定期更新镜像** - 获取最新功能和修复
3. **查看日志** - 遇到问题时第一时间查看日志
4. **数据持久化** - data/cache/generated 目录会保留你的数据

---

## 🔗 相关资源

- [Agent TARS 官网](https://agent-tars.com)
- [Agent TARS 文档](https://agent-tars.com/guide/get-started/quick-start.html)
- [GitHub 仓库](https://github.com/jamesxie2025/agent-tars-cli)
- [问题反馈](https://github.com/jamesxie2025/agent-tars-cli/issues)

