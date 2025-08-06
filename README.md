# FlyShadow Agent

> 🚀 **一条命令即可完成部署！** 支持 Linux、macOS 和 Windows 系统

## ⚡ 极速部署

**Linux/macOS**: 
```bash
curl -fsSL https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/deploy.sh | bash
```

**Windows**: 
```cmd
powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/deploy.bat' -OutFile 'deploy.bat'" && deploy.bat
```

## 📋 前置要求

- **Docker Desktop** 或 **Docker Engine** 已安装
- **Docker Compose** 已安装
- 网络连接正常（可以访问 GitHub）

## 🔧 自动执行的操作

1. ✅ **检查依赖** - 验证 Docker 和 Docker Compose 是否安装
2. ✅ **网络检测** - 检查是否可以访问 GitHub
3. ✅ **下载配置** - 自动下载最新的 `docker-compose.yml`
4. ✅ **拉取镜像** - 从 GitHub Container Registry 拉取最新镜像
5. ✅ **清理旧容器** - 停止并删除旧的容器（如果存在）
6. ✅ **启动服务** - 使用 docker-compose 启动服务
7. ✅ **状态检查** - 验证服务是否正常运行

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

## 📝 配置说明

部署脚本会自动创建配置文件，您可以通过修改脚本中的变量来自定义：

**Linux/macOS**:
```bash
AGENT_PASSWORD="your-password"
AGENT_NODE_ID="your-node-id"
```

**Windows**:
```cmd
set "AGENT_PASSWORD=your-password"
set "AGENT_NODE_ID=your-node-id"
```

## 🐛 故障排除

如果遇到问题，请检查：

1. **Docker 未安装** - 安装 [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. **网络连接失败** - 确保可以访问 GitHub
3. **镜像拉取失败** - 检查 GitHub Container Registry 连接
4. **端口被占用** - 检查端口 9999 是否被占用

## 📄 许可证

本项目遵循 MIT 许可证。

---

**详细文档**: [DEPLOY_README.md](DEPLOY_README.md) 