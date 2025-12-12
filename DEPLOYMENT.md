# Agent TARS 部署指南（Mac 版）

本指南适用于在 **Mac 电脑**（包括 Intel 和 Apple Silicon M 系列芯片）上部署 Agent TARS。

---

## 📋 部署前准备

### 1. 系统要求

- **操作系统**：macOS 10.15 或更高版本
- **芯片**：Intel 或 Apple Silicon (M1/M2/M3/M4)
- **内存**：建议至少 8GB RAM
- **磁盘空间**：至少 5GB 可用空间

### 2. 必需软件安装

#### 2.1 安装 Docker Desktop

1. **下载 Docker Desktop**：
   - 访问 [Docker 官网](https://www.docker.com/products/docker-desktop/)
   - 根据你的芯片类型选择：
     - **Apple Silicon (M1/M2/M3/M4)**：选择 "Mac with Apple chip"
     - **Intel 芯片**：选择 "Mac with Intel chip"

2. **安装 Docker Desktop**：
   - 双击下载的 `.dmg` 文件
   - 将 Docker 图标拖到 Applications 文件夹
   - 打开 Applications，双击 Docker 图标启动
   - 首次启动需要输入 Mac 密码授权

3. **验证 Docker 安装**：
   - 打开 **终端**（Terminal）应用
   - 输入以下命令并按回车：
     ```bash
     docker --version
     ```
   - 应该看到类似输出：`Docker version 24.x.x`

4. **验证 Docker Compose 安装**：
   - 在终端输入：
     ```bash
     docker-compose --version
     ```
   - 应该看到类似输出：`Docker Compose version v2.x.x`

#### 2.2 安装 Git

1. **检查是否已安装 Git**：
   - 打开终端，输入：
     ```bash
     git --version
     ```
   - 如果显示版本号（如 `git version 2.x.x`），说明已安装，跳到步骤 3

2. **安装 Git**（如果未安装）：
   - 在终端输入：
     ```bash
     xcode-select --install
     ```
   - 会弹出安装窗口，点击"安装"
   - 等待安装完成（可能需要几分钟）

### 3. 准备 API Key

Agent TARS 需要 AI 模型 API 才能工作。你需要至少准备以下其中一个：

#### 选项 1：DeepSeek API（推荐，性价比高）
1. 访问 [DeepSeek 官网](https://platform.deepseek.com/)
2. 注册账号并登录
3. 进入"API Keys"页面
4. 点击"创建新密钥"
5. 复制生成的 API Key（格式：`sk-xxxxxxxxxxxxxxxx`）
6. **重要**：保存好这个 Key，后面配置时需要用到

#### 选项 2：OpenAI API
1. 访问 [OpenAI 官网](https://platform.openai.com/)
2. 注册账号并登录
3. 进入"API Keys"页面
4. 创建新的 API Key
5. 复制并保存 API Key

#### 选项 3：其他兼容 OpenAI 的 API
- Anthropic Claude
- 阿里云 ModelScope
- 火山引擎 VolcEngine

---

## 🚀 部署步骤

### 步骤 1：克隆项目

1. **打开终端**

2. **选择一个目录存放项目**（例如在"文稿"目录下）：
   ```bash
   cd ~/Documents
   ```

3. **克隆项目**：
   ```bash
   git clone https://github.com/jamesxie2025/agent-tars-cli.git
   ```

4. **进入项目目录**：
   ```bash
   cd agent-tars-cli
   ```

### 步骤 2：配置 API Key

1. **复制环境变量模板**：
   ```bash
   cp .env.example .env
   ```

   **注意**：如果提示文件已存在，可以先删除旧的 `.env` 文件：
   ```bash
   rm .env
   cp .env.example .env
   ```

2. **编辑 .env 文件**：

   **方法 1：使用 nano 编辑器**（推荐新手）：
   ```bash
   nano .env
   ```

   **方法 2：使用文本编辑器**：
   ```bash
   open -e .env
   ```

3. **修改配置**（根据你选择的 API 提供商）：

   **如果使用 DeepSeek**（推荐）：
   ```bash
   TARS_MODEL_PROVIDER=openai
   TARS_MODEL_NAME=deepseek-chat
   TARS_MODEL_BASE_URL=https://api.deepseek.com
   TARS_MODEL_API_KEY=sk-你的DeepSeek-API-Key
   ```

   **重要**：将 `sk-你的DeepSeek-API-Key` 替换为你在步骤 3 中获取的真实 API Key

   **如果使用 OpenAI**：
   ```bash
   TARS_MODEL_PROVIDER=openai
   TARS_MODEL_NAME=gpt-4o
   TARS_MODEL_BASE_URL=https://api.openai.com/v1
   TARS_MODEL_API_KEY=sk-你的OpenAI-API-Key
   ```

   **重要**：将 `sk-你的OpenAI-API-Key` 替换为你的真实 API Key

4. **保存文件**：
   - 如果使用 nano：按 `Ctrl + X`，然后按 `Y`，最后按回车
   - 如果使用文本编辑器：按 `Command + S` 保存，然后关闭窗口

### 步骤 3：启动 Agent TARS

1. **拉取 Docker 镜像**：
   ```bash
   docker-compose pull
   ```
   
   这一步会下载镜像，可能需要几分钟，请耐心等待。

2. **启动容器**：
   ```bash
   docker-compose up -d
   ```

3. **等待启动**（约 30 秒）：
   ```bash
   sleep 30
   ```

4. **检查容器状态**：
   ```bash
   docker ps
   ```
   
   应该看到一个名为 `agent-tars` 的容器在运行。

5. **查看启动日志**（确认启动成功）：
   ```bash
   docker logs agent-tars
   ```
   
   应该看到类似输出：
   ```
   🎉  @agent-tars/core  is available at: http://localhost:8080
   📁 Workspace: /app/workspace
   🤖 Model: openai | deepseek-chat
   ```

### 步骤 4：访问 Agent TARS

1. **打开浏览器**（Safari、Chrome 等）

2. **访问地址**：
   ```
   http://localhost:8080
   ```

3. **开始使用**！你应该看到 Agent TARS 的 Web 界面

### 步骤 5：快速验证（可选）

验证所有功能是否正常工作：

1. **检查容器健康状态**：
   ```bash
   docker ps
   ```

   确认 STATUS 列显示 `Up X seconds (healthy)`

2. **检查浏览器功能**：
   ```bash
   docker exec agent-tars chromium --version
   ```

   应该显示：`Chromium 143.x.x.x built on Debian GNU/Linux 12 (bookworm)`

3. **检查 Python 环境**：
   ```bash
   docker exec agent-tars python3 --version
   ```

   应该显示：`Python 3.11.2`

4. **查看完整日志**（确认没有错误）：
   ```bash
   docker logs agent-tars 2>&1 | tail -30
   ```

---

## 🎯 使用示例

在 Agent TARS 界面中，你可以尝试以下任务：

### 1. 浏览器导航
```
请访问 https://www.weather.com.cn/weather/101280601.shtml 并提取深圳的天气信息
```

### 2. 数据分析
```
帮我分析一下这个 Excel 文件的销售数据
```
（需要先上传 Excel 文件）

### 3. 图表生成
```
请根据这些数据生成一个柱状图
```

### 4. 代码编写
```
帮我写一个 Python 脚本，用于批量重命名文件
```

---

## 🔧 常用命令

### 查看容器状态
```bash
docker ps
```

### 查看日志
```bash
docker logs agent-tars
```

### 实时查看日志
```bash
docker logs -f agent-tars
```

### 重启容器
```bash
docker-compose restart
```

### 停止容器
```bash
docker-compose down
```

### 启动容器
```bash
docker-compose up -d
```

### 更新到最新版本
```bash
docker-compose pull
docker-compose up -d
```

---

## ❓ 常见问题

### 1. 端口 8080 被占用

**错误信息**：`Bind for 0.0.0.0:8080 failed: port is already allocated`

**解决方法**：
1. 编辑 `docker-compose.yml` 文件
2. 将 `8080:8080` 改为 `8081:8080`（或其他未被占用的端口）
3. 重新启动：`docker-compose up -d`
4. 访问地址改为：`http://localhost:8081`

### 2. Docker Desktop 未启动

**错误信息**：`Cannot connect to the Docker daemon`

**解决方法**：
1. 打开 Applications 文件夹
2. 双击 Docker 图标启动 Docker Desktop
3. 等待 Docker 图标在菜单栏显示（鲸鱼图标）
4. 重新执行部署命令

### 3. API Key 无效

**错误信息**：在日志中看到 `401 Unauthorized` 或 `Invalid API Key`

**解决方法**：
1. 检查 `.env` 文件中的 API Key 是否正确
2. 确认 API Key 前后没有多余的空格
3. 确认 API Key 没有过期
4. 修改后重启容器：`docker-compose restart`

### 4. 浏览器功能不工作

**错误信息**：`Browser not initialized` 或 `Invalid search data format`

**解决方法**：
- 这个问题已在最新版本中修复
- 确保使用最新镜像：
  ```bash
  docker-compose pull
  docker-compose up -d
  ```

### 5. 容器启动后无法访问

**症状**：浏览器访问 http://localhost:8080 显示"无法连接"

**解决方法**：
1. 检查容器是否正在运行：
   ```bash
   docker ps | grep agent-tars
   ```

2. 如果容器未运行，查看错误日志：
   ```bash
   docker logs agent-tars
   ```

3. 检查端口是否被占用：
   ```bash
   lsof -i :8080
   ```

4. 等待容器完全启动（可能需要 30-60 秒）

### 6. 镜像拉取失败

**错误信息**：`Error response from daemon: Get https://ghcr.io/...`

**解决方法**：
1. 检查网络连接
2. 检查 Docker Desktop 是否正在运行
3. 尝试重新拉取：
   ```bash
   docker-compose pull --no-cache
   ```
4. 如果仍然失败，可能是网络问题，稍后重试

---

## 🔄 更新 Agent TARS

当有新版本发布时：

```bash
# 1. 进入项目目录
cd ~/Documents/agent-tars-cli

# 2. 拉取最新代码（如果有配置文件更新）
git pull

# 3. 拉取最新镜像
docker-compose pull

# 4. 重启容器
docker-compose up -d
```

---

## 🗑️ 完全卸载

如果需要完全删除 Agent TARS：

```bash
# 1. 停止并删除容器
docker-compose down

# 2. 删除镜像
docker rmi ghcr.io/jamesxie2025/agent-tars-cli:latest

# 3. 删除项目文件夹
cd ~
rm -rf ~/Documents/agent-tars-cli
```

---

## 📞 获取帮助

- **GitHub Issues**：https://github.com/jamesxie2025/agent-tars-cli/issues
- **Agent TARS 官网**：https://agent-tars.com
- **Agent TARS 文档**：https://agent-tars.com/guide/

---

## 📝 注意事项

1. **API 费用**：使用 AI 模型 API 会产生费用，请注意控制使用量
2. **数据安全**：不要在 Agent TARS 中处理敏感数据
3. **网络要求**：需要稳定的网络连接访问 AI API
4. **定期更新**：建议定期更新到最新版本以获得最佳体验

---

**祝你使用愉快！** 🎉

