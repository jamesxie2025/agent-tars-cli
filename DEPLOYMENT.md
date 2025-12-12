# Agent TARS Docker 部署指南（Mac 版）

本指南适用于在 **Mac 电脑**上使用 **Docker** 部署 Agent TARS。

## 🐳 关于 Docker 部署

Agent TARS 使用 **Docker 容器化部署**，具有以下优势：

- ✅ **环境隔离**：不会影响你的系统环境
- ✅ **一键部署**：无需手动安装 Python、Node.js、Chromium 等依赖
- ✅ **跨平台**：Docker 镜像在任何支持 Docker 的系统上都能运行
- ✅ **易于更新**：只需拉取最新镜像即可更新
- ✅ **易于卸载**：删除容器和镜像即可完全清理

**所有依赖都已打包在 Docker 镜像中**，包括：
- Chromium 浏览器（用于网页自动化）
- Python 3.11.2 + 数据分析库（pandas, matplotlib, seaborn, plotly, openpyxl, numpy）
- Node.js 22 + Agent TARS CLI
- MCP 服务器（文件系统、Excel、图表、Git、SQLite 等）

---

## 📋 部署前准备

### 1. 系统要求

- **操作系统**：macOS 10.15 或更高版本
- **芯片**：Intel 或 Apple Silicon (M1/M2/M3/M4)
- **内存**：建议至少 8GB RAM
- **磁盘空间**：至少 5GB 可用空间（用于 Docker 镜像和数据）
- **网络**：需要稳定的网络连接（下载 Docker 镜像约 2.7GB）

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

### 步骤 3：启动 Agent TARS（Docker 容器）

1. **拉取 Docker 镜像**（从 GitHub Container Registry）：
   ```bash
   docker-compose pull
   ```

   **说明**：
   - 这一步会从 GitHub 下载预构建的 Docker 镜像（约 2.7GB）
   - 镜像包含所有依赖：Chromium、Python、Node.js、MCP 服务器等
   - 首次下载可能需要 5-10 分钟（取决于网络速度）
   - 后续更新只需下载变化的部分，速度会快很多

2. **启动 Docker 容器**：
   ```bash
   docker-compose up -d
   ```

   **说明**：
   - `-d` 参数表示在后台运行容器
   - 容器名称：`agent-tars`
   - 端口映射：`8080:8080`（本地 8080 端口映射到容器 8080 端口）

3. **等待容器启动**（约 30 秒）：
   ```bash
   sleep 30
   ```

   **说明**：容器需要时间初始化 Agent TARS 服务

4. **检查容器状态**：
   ```bash
   docker ps
   ```

   **预期输出**：
   ```
   CONTAINER ID   IMAGE                                        STATUS                    PORTS
   xxxxxxxxxx     ghcr.io/jamesxie2025/agent-tars-cli:latest   Up 30 seconds (healthy)   0.0.0.0:8080->8080/tcp
   ```

   **重要**：确认 STATUS 列显示 `(healthy)`，表示容器健康检查通过

5. **查看启动日志**（确认启动成功）：
   ```bash
   docker logs agent-tars
   ```

   **预期输出**：
   ```
   +------------------------------------------------------------------+
   |                                                                  |
   |   🎉  @agent-tars/core  is available at: http://localhost:8080   |
   |                                                                  |
   |   📁 Workspace: /app/workspace                                   |
   |                                                                  |
   |   🤖 Model: openai | deepseek-chat                               |
   |                                                                  |
   +------------------------------------------------------------------+
   ```

### 步骤 4：访问 Agent TARS

1. **打开浏览器**（Safari、Chrome 等）

2. **访问地址**：
   ```
   http://localhost:8080
   ```

3. **开始使用**！你应该看到 Agent TARS 的 Web 界面

### 步骤 5：快速验证（可选但推荐）

验证 Docker 容器中的所有功能是否正常工作：

1. **检查容器健康状态**：
   ```bash
   docker ps
   ```

   **预期输出**：
   ```
   STATUS
   Up X seconds (healthy)
   ```

   **说明**：`(healthy)` 表示容器通过了健康检查

2. **检查浏览器功能**（在容器内执行）：
   ```bash
   docker exec agent-tars chromium --version
   ```

   **预期输出**：
   ```
   Chromium 143.x.x.x built on Debian GNU/Linux 12 (bookworm)
   ```

   **说明**：`docker exec` 命令在运行中的容器内执行命令

3. **检查 Python 环境**（在容器内执行）：
   ```bash
   docker exec agent-tars python3 --version
   ```

   **预期输出**：
   ```
   Python 3.11.2
   ```

4. **检查 Python 数据分析库**（在容器内执行）：
   ```bash
   docker exec agent-tars python3 -c "import pandas, matplotlib, seaborn, plotly, openpyxl, numpy; print('✅ All libraries installed')"
   ```

   **预期输出**：
   ```
   ✅ All libraries installed
   ```

5. **查看完整日志**（确认没有错误）：
   ```bash
   docker logs agent-tars 2>&1 | tail -30
   ```

   **说明**：检查是否有 ERROR 或 FAILED 等错误信息

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

### Docker 容器管理

#### 查看容器状态
```bash
docker ps
```
**说明**：显示所有运行中的容器

#### 查看所有容器（包括停止的）
```bash
docker ps -a
```

#### 查看日志
```bash
docker logs agent-tars
```
**说明**：查看容器的所有日志输出

#### 实时查看日志
```bash
docker logs -f agent-tars
```
**说明**：`-f` 参数表示持续跟踪日志输出（类似 `tail -f`）

#### 重启容器
```bash
docker-compose restart
```
**说明**：重启容器，保留数据

#### 停止容器
```bash
docker-compose down
```
**说明**：停止并删除容器，但保留镜像和数据卷

#### 启动容器
```bash
docker-compose up -d
```
**说明**：启动容器（如果容器不存在则创建）

#### 更新到最新版本
```bash
docker-compose pull
docker-compose up -d
```
**说明**：
1. 拉取最新的 Docker 镜像
2. 重新创建并启动容器

### 在容器内执行命令

#### 进入容器 Shell
```bash
docker exec -it agent-tars sh
```
**说明**：进入容器的交互式 Shell，可以执行任何命令

#### 在容器内执行单个命令
```bash
docker exec agent-tars <命令>
```
**示例**：
```bash
# 查看容器内的文件
docker exec agent-tars ls -la /app

# 查看环境变量
docker exec agent-tars env | grep TARS

# 测试浏览器
docker exec agent-tars chromium --version
```

### 数据管理

#### 查看数据卷
```bash
docker volume ls
```

#### 清理未使用的数据
```bash
# 清理停止的容器
docker container prune

# 清理未使用的镜像
docker image prune

# 清理所有未使用的资源（谨慎使用）
docker system prune
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

如果需要完全删除 Agent TARS（包括 Docker 容器、镜像和数据）：

### 方法 1：保留数据（推荐）

```bash
# 1. 进入项目目录
cd ~/Documents/agent-tars-cli

# 2. 停止并删除容器
docker-compose down

# 3. 删除 Docker 镜像
docker rmi ghcr.io/jamesxie2025/agent-tars-cli:latest
```

**说明**：这种方法会保留项目文件夹和数据（data/、cache/、generated/），方便以后重新部署

### 方法 2：完全删除（包括数据）

```bash
# 1. 进入项目目录
cd ~/Documents/agent-tars-cli

# 2. 停止并删除容器
docker-compose down

# 3. 删除 Docker 镜像
docker rmi ghcr.io/jamesxie2025/agent-tars-cli:latest

# 4. 删除项目文件夹（包括所有数据）
cd ~
rm -rf ~/Documents/agent-tars-cli
```

**警告**：这会删除所有数据，包括生成的文件、缓存等，无法恢复！

### 检查是否完全卸载

```bash
# 检查容器是否已删除
docker ps -a | grep agent-tars

# 检查镜像是否已删除
docker images | grep agent-tars-cli

# 检查项目文件夹是否已删除
ls ~/Documents/agent-tars-cli
```

如果以上命令都没有输出，说明已完全卸载。

---

## 🏗️ Docker 环境架构

### 容器内部结构

```
Docker 容器 (agent-tars)
├── 操作系统: Debian GNU/Linux 12 (bookworm)
├── Node.js: v22.x
├── Python: 3.11.2
├── Chromium: 143.0.7499.40
│
├── /app/                          # 应用目录
│   ├── agent.config.ts            # Agent TARS 配置文件
│   ├── data/                      # 数据目录（映射到本地）
│   ├── cache/                     # 缓存目录（映射到本地）
│   ├── generated/                 # 生成文件目录（映射到本地）
│   └── workspace/                 # 工作目录（映射到本地）
│
└── 已安装的软件包
    ├── @agent-tars/cli@0.3.0      # Agent TARS CLI
    ├── Python 库
    │   ├── pandas                 # 数据分析
    │   ├── matplotlib             # 数据可视化
    │   ├── seaborn                # 统计可视化
    │   ├── plotly                 # 交互式图表
    │   ├── openpyxl               # Excel 处理
    │   └── numpy                  # 数值计算
    └── MCP 服务器
        ├── @modelcontextprotocol/server-filesystem
        ├── @negokaz/excel-mcp-server
        ├── @antv/mcp-server-chart
        ├── @modelcontextprotocol/server-memory
        ├── @modelcontextprotocol/server-git
        └── @modelcontextprotocol/server-sqlite
```

### 端口映射

```
本地 Mac                    Docker 容器
localhost:8080    ←→    容器内部:8080 (Agent TARS Web UI)
```

### 目录映射（Volume）

```
本地 Mac                              Docker 容器
~/Documents/agent-tars-cli/data       ←→    /app/data
~/Documents/agent-tars-cli/cache      ←→    /app/cache
~/Documents/agent-tars-cli/generated  ←→    /app/generated
~/Documents/agent-tars-cli/workspace  ←→    /app/workspace
```

**说明**：
- 这些目录在本地和容器之间是**同步**的
- 在容器内生成的文件会自动保存到本地
- 删除容器不会删除这些数据

### 网络

```
本地浏览器
    ↓
http://localhost:8080
    ↓
Docker 端口映射 (8080:8080)
    ↓
容器内 Agent TARS 服务
    ↓
AI API (DeepSeek/OpenAI/etc.)
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

