# FlyShadow Agent 一键部署指南

## 🚀 快速开始

### Linux/macOS 用户

```bash
# 下载并运行部署脚本
curl -fsSL https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/deploy.sh | bash

# 或者下载后运行
wget https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/deploy.sh
chmod +x deploy.sh
./deploy.sh
```

### Windows 用户

```cmd
# 下载并运行部署脚本
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/deploy.bat' -OutFile 'deploy.bat'"
deploy.bat
```

## 📋 前置要求

- **Docker Desktop** 或 **Docker Engine** 已安装
- **Docker Compose** 已安装
- 网络连接正常（可以访问 GitHub）

## 🔧 脚本功能

### 自动执行的操作：

1. ✅ **检查依赖** - 验证 Docker 和 Docker Compose 是否安装
2. ✅ **网络检测** - 检查是否可以访问 GitHub
3. ✅ **下载配置** - 自动下载最新的 `docker-compose.yml`
4. ✅ **拉取镜像** - 从 GitHub Container Registry 拉取最新镜像
5. ✅ **清理旧容器** - 停止并删除旧的容器（如果存在）
6. ✅ **启动服务** - 使用 docker-compose 启动服务
7. ✅ **状态检查** - 验证服务是否正常运行

### 脚本选项：

```bash
# 正常部署
./deploy.sh

# 强制重新部署（停止并删除现有容器）
./deploy.sh --force

# 仅更新镜像和配置文件
./deploy.sh --update

# 显示帮助信息
./deploy.sh --help
```

## 📊 服务信息

部署成功后，您将看到：

- **容器名称**: `flyshadow-agent`
- **镜像**: `ghcr.io/sebastian0619/flyshadow-agent:latest`
- **网络模式**: host (直接使用主机网络)
- **端口**: 9999
- **访问地址**: http://localhost:9999
- **配置文件**: `./config.yaml` (自动生成)

## 🔧 常用命令

```bash
# 查看服务日志
docker logs flyshadow-agent

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 更新服务
./deploy.sh

# 查看服务状态
docker ps | grep flyshadow-agent
```

## 🐛 故障排除

### 常见问题：

1. **Docker 未安装**
   ```
   [ERROR] Docker 未安装，请先安装 Docker
   ```
   **解决方案**: 安装 [Docker Desktop](https://www.docker.com/products/docker-desktop/)

2. **网络连接失败**
   ```
   [ERROR] 无法连接到 GitHub，请检查网络连接
   ```
   **解决方案**: 检查网络连接，确保可以访问 GitHub

3. **镜像拉取失败**
   ```
   [ERROR] 镜像拉取失败
   ```
   **解决方案**: 
   - 检查网络连接
   - 确保 GitHub Container Registry 可访问
   - 尝试手动拉取：`docker pull ghcr.io/sebastian0619/flyshadow-agent:main`

4. **端口被占用**
   ```
   [ERROR] 服务启动失败
   ```
   **解决方案**: 
   - 检查端口 9999 是否被占用：`netstat -tulpn | grep 9999`
   - 修改 `docker-compose.yml` 中的端口映射

## 🔄 更新服务

要更新到最新版本，只需重新运行部署脚本：

```bash
./deploy.sh
```

脚本会自动：
- 下载最新的配置文件
- 拉取最新的镜像
- 重启服务

## 📝 配置文件

### 环境变量配置

您可以通过修改脚本中的配置变量来自定义Agent设置：

**Linux/macOS (deploy.sh)**:
```bash
# Agent配置变量 - 用户可以根据需要修改
AGENT_PASSWORD="${AGENT_PASSWORD:-12c5a79c-b3a5-11ef-a595-0016d7606fb8}"
AGENT_NODE_ID="${AGENT_NODE_ID:-165}"
```

**Windows (deploy.bat)**:
```cmd
REM 配置变量 - 用户可以根据需要修改
set "AGENT_PASSWORD=12c5a79c-b3a5-11ef-a595-0016d7606fb8"
set "AGENT_NODE_ID=165"
```

### 自动生成的配置文件

部署脚本会自动创建 `config.yaml` 文件：

```yaml
password: 12c5a79c-b3a5-11ef-a595-0016d7606fb8
node_id: 
  - 165
```

### Docker Compose 配置

部署脚本会自动下载 `docker-compose.yml` 文件：

```yaml
version: '3.8'

services:
  flyshadow-agent:
    image: ghcr.io/sebastian0619/flyshadow-agent:latest
    container_name: flyshadow-agent
    network_mode: host  # 使用主机网络模式
    restart: unless-stopped
    environment:
      - AGENT_PASSWORD=${AGENT_PASSWORD:-12c5a79c-b3a5-11ef-a595-0016d7606fb8}
      - AGENT_NODE_ID=${AGENT_NODE_ID:-165}
    volumes:
      - ./config.yaml:/app/config.yaml:ro  # 配置文件挂载
```

## 🆘 获取帮助

如果遇到问题，可以：

1. 查看服务日志：`docker logs flyshadow-agent`
2. 检查容器状态：`docker ps -a`
3. 提交 Issue：https://github.com/sebastian0619/flyshadow-agent/issues

## 📄 许可证

本项目遵循 MIT 许可证。 