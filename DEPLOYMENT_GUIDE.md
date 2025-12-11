# Agent TARS CLI - 部署指南（适用于任何 Mac 电脑）

本指南适用于在任何 Mac 电脑（包括 Intel 和 Apple Silicon M1/M2/M3/M4）上部署 Agent TARS。

---

## 📋 前置要求

### 1. 安装 Docker Desktop

**下载地址：** https://www.docker.com/products/docker-desktop/

**安装步骤：**
1. 下载适合您 Mac 的版本（Intel 或 Apple Silicon）
2. 打开 `.dmg` 文件
3. 将 Docker 拖到 Applications 文件夹
4. 启动 Docker Desktop
5. 等待 Docker 启动完成（菜单栏会显示 Docker 图标）

**验证安装：**
```bash
docker --version
docker-compose --version
```

### 2. 安装 Git（可选，如果要克隆仓库）

Mac 通常自带 Git，验证：
```bash
git --version
```

如果没有，安装 Xcode Command Line Tools：
```bash
xcode-select --install
```

---

## 🚀 部署步骤

### 方法 1：使用 Git 克隆仓库（推荐）

#### 步骤 1：克隆仓库

```bash
# 克隆仓库到本地
git clone https://github.com/jamesxie2025/agent-tars-cli.git

# 进入项目目录
cd agent-tars-cli
```

#### 步骤 2：配置环境变量

```bash
# 复制示例配置文件
cp .env.example .env

# 编辑配置文件
nano .env
```

**必须配置的内容：**

```bash
# 选择一个 AI 提供商并配置 API 密钥

# 选项 1：使用 ModelScope（推荐，适合中国用户）
TARS_MODEL_PROVIDER=openai
TARS_MODEL_NAME=Qwen/Qwen3-Coder-480B-A35B-Instruct
TARS_MODEL_BASE_URL=https://api-inference.modelscope.cn/v1/
TARS_MODEL_API_KEY=ms-your-api-key-here  # 替换为您的 API 密钥
MODELSCOPE_API_KEY=ms-your-api-key-here  # 同上

# 选项 2：使用 OpenAI
# TARS_MODEL_PROVIDER=openai
# TARS_MODEL_NAME=gpt-4o
# TARS_MODEL_BASE_URL=
# TARS_MODEL_API_KEY=sk-your-openai-api-key-here
# OPENAI_API_KEY=sk-your-openai-api-key-here

# 选项 3：使用 DeepSeek
# TARS_MODEL_PROVIDER=deepseek
# TARS_MODEL_NAME=deepseek-chat
# TARS_MODEL_BASE_URL=
# TARS_MODEL_API_KEY=sk-your-deepseek-api-key-here
# DEEPSEEK_API_KEY=sk-your-deepseek-api-key-here
```

**保存文件：**
- 按 `Ctrl + O` 保存
- 按 `Enter` 确认
- 按 `Ctrl + X` 退出

#### 步骤 3：启动容器

```bash
# 拉取最新镜像并启动
docker-compose up -d
```

#### 步骤 4：验证部署

```bash
# 查看容器状态
docker-compose ps

# 查看日志
docker logs agent-tars

# 应该看到类似输出：
# 🤖 Model: openai | Qwen/Qwen3-Coder-480B-A35B-Instruct
# 🎉  @agent-tars/core  is available at: http://localhost:8080
```

#### 步骤 5：访问 Web 界面

在浏览器中打开：**http://localhost:8080**

---

### 方法 2：手动下载配置文件（无需 Git）

#### 步骤 1：创建项目目录

```bash
# 创建目录
mkdir -p ~/agent-tars-cli
cd ~/agent-tars-cli
```

#### 步骤 2：下载配置文件

从 GitHub 下载以下文件：
- `docker-compose.yml`
- `.env.example`
- `mcp-config.ts`（可选）

**方法 A：使用 curl 下载**

```bash
# 下载 docker-compose.yml
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/docker-compose.yml

# 下载 .env.example
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/.env.example

# 下载 mcp-config.ts（可选）
curl -O https://raw.githubusercontent.com/jamesxie2025/agent-tars-cli/main/mcp-config.ts
```

**方法 B：手动下载**

访问 https://github.com/jamesxie2025/agent-tars-cli 并下载文件。

#### 步骤 3：配置环境变量

```bash
# 复制配置文件
cp .env.example .env

# 编辑配置（参考方法 1 的步骤 2）
nano .env
```

#### 步骤 4：启动容器

```bash
docker-compose up -d
```

#### 步骤 5：验证和访问

同方法 1 的步骤 4 和 5。

---

## 📝 获取 API 密钥

### ModelScope（推荐，免费额度）
1. 访问：https://modelscope.cn/my/myaccesstoken
2. 登录/注册账号
3. 创建 API Token
4. 复制 `ms-` 开头的密钥

### OpenAI
1. 访问：https://platform.openai.com/api-keys
2. 登录账号
3. 创建新的 API Key
4. 复制 `sk-` 开头的密钥

### DeepSeek
1. 访问：https://platform.deepseek.com/api_keys
2. 登录/注册账号
3. 创建 API Key
4. 复制密钥

---

## 🔧 常用命令

### 启动服务
```bash
docker-compose up -d
```

### 停止服务
```bash
docker-compose down
```

### 重启服务
```bash
docker-compose restart
```

### 查看日志
```bash
# 查看所有日志
docker logs agent-tars

# 实时查看日志
docker logs -f agent-tars

# 查看最后 50 行
docker logs --tail 50 agent-tars
```

### 查看容器状态
```bash
docker-compose ps
```

### 更新到最新版本
```bash
# 拉取最新镜像
docker-compose pull

# 重启容器
docker-compose down
docker-compose up -d
```

### 进入容器（调试用）
```bash
docker exec -it agent-tars sh
```

---

## 🛠️ 故障排除

### 问题 1：端口 8080 已被占用

**错误信息：** `Bind for 0.0.0.0:8080 failed: port is already allocated`

**解决方法：**

编辑 `.env` 文件，修改端口：
```bash
PORT=8081  # 或其他未使用的端口
```

然后重启：
```bash
docker-compose down
docker-compose up -d
```

访问地址变为：http://localhost:8081

### 问题 2：Connection error（连接错误）

**原因：** API 密钥未配置或配置错误

**解决方法：**
1. 检查 `.env` 文件中的 API 密钥是否正确
2. 确认 `TARS_MODEL_API_KEY` 已设置
3. 重启容器：
```bash
docker-compose down
docker-compose up -d
```

### 问题 3：Docker Desktop 未启动

**错误信息：** `Cannot connect to the Docker daemon`

**解决方法：**
1. 启动 Docker Desktop 应用
2. 等待 Docker 完全启动（菜单栏显示 Docker 图标）
3. 重新运行命令

### 问题 4：镜像拉取失败

**错误信息：** `Error response from daemon: Get https://ghcr.io/...`

**解决方法：**
1. 检查网络连接
2. 如果在中国，可能需要配置 Docker 镜像加速
3. 或使用 VPN

---

## 📚 更多文档

- **配置指南：** 查看 `CONFIGURATION.md` 了解如何更换模型
- **清理指南：** 查看 `DOCKER_CLEANUP.md` 了解如何清理 Docker 资源
- **项目主页：** https://github.com/jamesxie2025/agent-tars-cli
- **Agent TARS 官网：** https://agent-tars.com

---

## ✅ 快速检查清单

部署前确认：
- [ ] Docker Desktop 已安装并运行
- [ ] 已获取 AI 提供商的 API 密钥
- [ ] 已创建并配置 `.env` 文件
- [ ] 端口 8080 未被占用（或已修改为其他端口）

部署后验证：
- [ ] `docker-compose ps` 显示容器正在运行
- [ ] `docker logs agent-tars` 显示模型已加载
- [ ] 浏览器可以访问 http://localhost:8080
- [ ] Web 界面左上角显示模型信息
- [ ] 可以正常与 AI 对话

---

## 🎉 完成！

现在您可以开始使用 Agent TARS 了！

如有问题，请访问：https://github.com/jamesxie2025/agent-tars-cli/issues

