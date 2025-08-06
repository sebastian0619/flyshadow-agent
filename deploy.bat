@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM FlyShadow Agent 一键部署脚本 (Windows版本)
REM 作者: Sebastian
REM 仓库: https://github.com/sebastian0619/flyshadow-agent

set "REPO_URL=https://github.com/sebastian0619/flyshadow-agent"
set "DOCKER_COMPOSE_URL=https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/docker-compose.yml"
set "IMAGE_NAME=ghcr.io/sebastian0619/flyshadow-agent:latest"
set "CONTAINER_NAME=flyshadow-agent"

REM 配置变量 - 用户可以根据需要修改
set "AGENT_PASSWORD=12c5a79c-b3a5-11ef-a595-0016d7606fb8"
set "AGENT_NODE_ID=165"

echo 🚀 FlyShadow Agent 一键部署脚本 (Windows版本)
echo ================================================
echo.

REM 检查Docker是否安装
echo [STEP] 检查Docker安装状态...
docker --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker 未安装，请先安装 Docker Desktop
    pause
    exit /b 1
)

docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker Compose 未安装，请先安装 Docker Compose
    pause
    exit /b 1
)

echo [INFO] Docker 和 Docker Compose 已安装

REM 检查网络连接
echo [STEP] 检查网络连接...
curl -s --connect-timeout 5 https://github.com >nul 2>&1
if errorlevel 1 (
    echo [ERROR] 无法连接到 GitHub，请检查网络连接
    pause
    exit /b 1
)
echo [INFO] 网络连接正常

REM 下载或更新 docker-compose.yml
echo [STEP] 下载/更新 docker-compose.yml...
curl -s -o docker-compose.yml "%DOCKER_COMPOSE_URL%"
if errorlevel 1 (
    echo [ERROR] 下载 docker-compose.yml 失败
    pause
    exit /b 1
)
echo [INFO] docker-compose.yml 下载成功

REM 创建配置文件
echo [STEP] 创建配置文件...
(
echo password: %AGENT_PASSWORD%
echo node_id: 
echo   - %AGENT_NODE_ID%
) > config.yaml
if errorlevel 1 (
    echo [ERROR] 创建 config.yaml 失败
    pause
    exit /b 1
)
echo [INFO] config.yaml 创建成功

REM 拉取最新镜像
echo [STEP] 拉取最新 Docker 镜像...
docker pull "%IMAGE_NAME%"
if errorlevel 1 (
    echo [ERROR] 镜像拉取失败
    pause
    exit /b 1
)
echo [INFO] 镜像拉取成功

REM 停止并删除旧容器
echo [STEP] 清理旧容器...
docker ps -a --format "table {{.Names}}" | findstr /c:"%CONTAINER_NAME%" >nul
if not errorlevel 1 (
    echo [WARNING] 发现旧容器，正在停止并删除...
    docker stop "%CONTAINER_NAME%" >nul 2>&1
    docker rm "%CONTAINER_NAME%" >nul 2>&1
    echo [INFO] 旧容器清理完成
) else (
    echo [INFO] 没有发现旧容器
)

REM 启动服务
echo [STEP] 启动 FlyShadow Agent 服务...
docker-compose up -d
if errorlevel 1 (
    echo [ERROR] 服务启动失败
    pause
    exit /b 1
)
echo [INFO] 服务启动成功

REM 检查服务状态
echo [STEP] 检查服务状态...
timeout /t 3 /nobreak >nul

docker ps --format "table {{.Names}}" | findstr /c:"%CONTAINER_NAME%" >nul
if not errorlevel 1 (
    echo [INFO] ✅ FlyShadow Agent 运行正常
    echo.
    echo 📊 服务信息：
    echo    - 容器名称: %CONTAINER_NAME%
    echo    - 镜像: %IMAGE_NAME%
    echo    - 端口: 9999
    echo    - 访问地址: http://localhost:9999
    echo.
    echo 🔧 常用命令：
    echo    - 查看日志: docker logs %CONTAINER_NAME%
    echo    - 停止服务: docker-compose down
    echo    - 重启服务: docker-compose restart
    echo    - 更新服务: deploy.bat
) else (
    echo [ERROR] ❌ 服务启动失败，请检查日志
    docker logs "%CONTAINER_NAME%" 2>nul
    pause
    exit /b 1
)

echo.
echo ✅ 部署完成！
pause 