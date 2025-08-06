# GitHub Actions 自动构建说明

## 工作流功能

这个GitHub Actions工作流会自动构建多架构的Docker镜像，支持：

- **触发条件**：
  - 推送到 `main` 或 `master` 分支
  - 创建版本标签（如 `v1.0.0`）
  - 创建Pull Request

- **支持的架构**：
  - `linux/amd64` (x86_64)
  - `linux/arm64` (ARM64)

- **镜像仓库**：
  - 使用GitHub Container Registry (ghcr.io)
  - 镜像名称：`ghcr.io/你的用户名/flyshadow-agent`

## 标签策略

工作流会自动生成以下标签：

- **分支标签**：`ghcr.io/用户名/flyshadow-agent:main`
- **版本标签**：`ghcr.io/用户名/flyshadow-agent:v1.0.0`
- **语义版本**：`ghcr.io/用户名/flyshadow-agent:1.0`
- **提交哈希**：`ghcr.io/用户名/flyshadow-agent:sha-abc123`

## 使用方法

### 1. 推送代码触发构建

```bash
git push origin main
```

### 2. 创建版本标签

```bash
git tag v1.0.0
git push origin v1.0.0
```

### 3. 拉取镜像

```bash
# 拉取最新版本
docker pull ghcr.io/你的用户名/flyshadow-agent:main

# 拉取特定版本
docker pull ghcr.io/你的用户名/flyshadow-agent:v1.0.0

# 拉取特定架构
docker pull --platform linux/amd64 ghcr.io/你的用户名/flyshadow-agent:main
docker pull --platform linux/arm64 ghcr.io/你的用户名/flyshadow-agent:main
```

### 4. 运行容器

```bash
# 运行容器
docker run -d -p 9999:9999 --name flyshadow-agent ghcr.io/你的用户名/flyshadow-agent:main
```

## 注意事项

1. **权限设置**：确保仓库有 `packages: write` 权限
2. **公开镜像**：如果需要公开镜像，需要在GitHub Packages设置中配置
3. **缓存优化**：工作流使用了GitHub Actions缓存来加速构建
4. **多架构支持**：Docker会自动选择适合当前系统的架构版本

## 故障排除

如果构建失败，请检查：

1. 二进制文件是否存在且可执行
2. Dockerfile语法是否正确
3. GitHub Actions权限设置
4. 网络连接是否正常 