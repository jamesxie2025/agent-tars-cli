# 快速开始指南

## 🚀 3 步启动 Agent TARS

### 步骤 1: 克隆仓库

```bash
git clone https://github.com/jamesxie2025/agent-tars-cli.git
cd agent-tars-cli
```

### 步骤 2: 配置 API Key

```bash
cp .env.example .env
nano .env  # 填入你的 API Key
```

### 步骤 3: 启动

```bash
./run.sh
```

或使用 Make:

```bash
make quick-start
```

或使用 Docker Compose:

```bash
docker-compose pull
docker-compose up -d
```

## 🌐 访问

打开浏览器: **http://localhost:8080**

## 📝 常用命令

```bash
make help      # 查看所有命令
make logs      # 查看日志
make restart   # 重启服务
make stop      # 停止服务
make update    # 更新到最新版本
```

## ❓ 需要帮助？

查看 [INSTALL.md](INSTALL.md) 获取详细安装说明。
