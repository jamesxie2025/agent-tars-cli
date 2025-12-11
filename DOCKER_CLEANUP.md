# Docker 清理指南

## 查看 Docker 镜像

```bash
# 查看所有镜像
docker images

# 查看悬空镜像（无标签的镜像）
docker images -f "dangling=true"
```

## 清理无效镜像

### 方法 1：删除特定镜像

```bash
# 通过镜像 ID 删除
docker rmi <IMAGE_ID>

# 通过镜像名称删除
docker rmi <IMAGE_NAME>:<TAG>

# 强制删除（如果镜像正在被使用）
docker rmi -f <IMAGE_ID>
```

### 方法 2：删除所有悬空镜像（推荐）

```bash
# 删除所有 <none> 标签的镜像
docker image prune

# 不询问直接删除
docker image prune -f
```

### 方法 3：删除所有未使用的镜像

```bash
# 删除所有未被容器使用的镜像
docker image prune -a

# 不询问直接删除
docker image prune -a -f
```

## 清理其他 Docker 资源

### 清理停止的容器

```bash
# 删除所有停止的容器
docker container prune

# 不询问直接删除
docker container prune -f
```

### 清理未使用的卷

```bash
# 删除未使用的卷
docker volume prune

# 不询问直接删除
docker volume prune -f
```

### 清理未使用的网络

```bash
# 删除未使用的网络
docker network prune

# 不询问直接删除
docker network prune -f
```

### 一键清理所有未使用资源（推荐）

```bash
# 清理所有未使用的容器、网络、镜像（悬空的）
docker system prune

# 清理所有未使用的资源，包括所有未使用的镜像
docker system prune -a

# 不询问直接清理
docker system prune -a -f

# 同时清理卷
docker system prune -a --volumes -f
```

## 查看 Docker 占用空间

```bash
# 查看 Docker 占用的磁盘空间
docker system df

# 详细信息
docker system df -v
```

## 示例：清理 Agent TARS 旧镜像

```bash
# 1. 查看所有 agent-tars 相关镜像
docker images | grep agent-tars

# 2. 保留最新的，删除旧的
docker rmi ghcr.io/jamesxie2025/agent-tars-cli:sha256-xxxxx

# 3. 或者直接清理所有悬空镜像
docker image prune -f
```

## 安全提示

⚠️ **注意事项：**
- `docker image prune` 只删除悬空镜像（`<none>`），安全
- `docker image prune -a` 会删除所有未使用的镜像，包括有标签的
- `docker system prune -a --volumes` 会删除所有数据，包括卷中的数据
- 删除前请确认不需要这些镜像或数据

## 推荐清理流程

```bash
# 步骤 1：查看当前占用
docker system df

# 步骤 2：清理停止的容器
docker container prune -f

# 步骤 3：清理悬空镜像
docker image prune -f

# 步骤 4：（可选）清理所有未使用的镜像
docker image prune -a -f

# 步骤 5：查看清理后的占用
docker system df
```

