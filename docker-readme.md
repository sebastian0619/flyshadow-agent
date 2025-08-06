# Docker 部署说明

## 构建镜像

```bash
# 构建Docker镜像
docker build -t flyshadow-agent .

# 或者指定标签
docker build -t flyshadow-agent:latest .
```

## 运行容器

```bash
# 运行容器，映射端口9999
docker run -d -p 9999:9999 --name flyshadow-agent flyshadow-agent

# 或者指定端口映射
docker run -d -p 8080:9999 --name flyshadow-agent flyshadow-agent
```

## 查看日志

```bash
# 查看容器日志
docker logs flyshadow-agent

# 实时查看日志
docker logs -f flyshadow-agent
```

## 停止和删除容器

```bash
# 停止容器
docker stop flyshadow-agent

# 删除容器
docker rm flyshadow-agent
```

## 多架构支持

这个Dockerfile支持以下架构：
- x86_64/amd64: 使用 `agent(x64)` 二进制文件
- aarch64/arm64/arm: 使用 `agent(ARM)` 二进制文件

容器会自动检测系统架构并选择相应的二进制程序运行。

## 环境变量

如果需要传递环境变量给agent程序，可以使用：

```bash
docker run -d -p 9999:9999 -e ENV_VAR=value --name flyshadow-agent flyshadow-agent
``` 