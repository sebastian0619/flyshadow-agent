#!/bin/bash

# FlyShadow Agent 一键部署脚本
# 作者: Sebastian
# 仓库: https://github.com/sebastian0619/flyshadow-agent

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
REPO_URL="https://github.com/sebastian0619/flyshadow-agent"
DOCKER_COMPOSE_URL="https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/docker-compose.yml"
IMAGE_NAME="ghcr.io/sebastian0619/flyshadow-agent:latest"
CONTAINER_NAME="flyshadow-agent"

# Agent配置变量 - 用户可以根据需要修改
AGENT_PASSWORD="${AGENT_PASSWORD:-12c5a79c-b3a5-11ef-a595-0016d7606fb8}"
AGENT_NODE_ID="${AGENT_NODE_ID:-165}"

# 打印带颜色的消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# 检查Docker是否安装
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker 未安装，请先安装 Docker"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose 未安装，请先安装 Docker Compose"
        exit 1
    fi
    
    print_message "Docker 和 Docker Compose 已安装"
}

# 检查网络连接
check_network() {
    print_step "检查网络连接..."
    if ! curl -s --connect-timeout 5 https://github.com > /dev/null; then
        print_error "无法连接到 GitHub，请检查网络连接"
        exit 1
    fi
    print_message "网络连接正常"
}

# 下载或更新 docker-compose.yml
download_compose() {
    print_step "下载/更新 docker-compose.yml..."
    
    if curl -s -o docker-compose.yml "$DOCKER_COMPOSE_URL"; then
        print_message "docker-compose.yml 下载成功"
    else
        print_error "下载 docker-compose.yml 失败"
        exit 1
    fi
}

# 创建配置文件
create_config() {
    print_step "创建配置文件..."
    
    cat > config.yaml << EOF
password: $AGENT_PASSWORD
node_id: 
  - $AGENT_NODE_ID
EOF
    
    if [ $? -eq 0 ]; then
        print_message "config.yaml 创建成功"
    else
        print_error "创建 config.yaml 失败"
        exit 1
    fi
}

# 拉取最新镜像
pull_image() {
    print_step "拉取最新 Docker 镜像..."
    
    if docker pull "$IMAGE_NAME"; then
        print_message "镜像拉取成功"
    else
        print_error "镜像拉取失败"
        exit 1
    fi
}

# 停止并删除旧容器
cleanup_old_container() {
    print_step "清理旧容器..."
    
    if docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        print_warning "发现旧容器，正在停止并删除..."
        docker stop "$CONTAINER_NAME" 2>/dev/null || true
        docker rm "$CONTAINER_NAME" 2>/dev/null || true
        print_message "旧容器清理完成"
    else
        print_message "没有发现旧容器"
    fi
}

# 启动服务
start_service() {
    print_step "启动 FlyShadow Agent 服务..."
    
    if docker-compose up -d; then
        print_message "服务启动成功"
    else
        print_error "服务启动失败"
        exit 1
    fi
}

# 检查服务状态
check_status() {
    print_step "检查服务状态..."
    
    sleep 3
    
    if docker ps --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        print_message "✅ FlyShadow Agent 运行正常"
        echo ""
        echo "📊 服务信息："
        echo "   - 容器名称: $CONTAINER_NAME"
        echo "   - 镜像: $IMAGE_NAME"
        echo "   - 端口: 9999"
        echo "   - 访问地址: http://localhost:9999"
        echo ""
        echo "🔧 常用命令："
        echo "   - 查看日志: docker logs $CONTAINER_NAME"
        echo "   - 停止服务: docker-compose down"
        echo "   - 重启服务: docker-compose restart"
        echo "   - 更新服务: ./deploy.sh"
    else
        print_error "❌ 服务启动失败，请检查日志"
        docker logs "$CONTAINER_NAME" 2>/dev/null || true
        exit 1
    fi
}

# 显示帮助信息
show_help() {
    echo "FlyShadow Agent 一键部署脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help     显示此帮助信息"
    echo "  -f, --force    强制重新部署（停止并删除现有容器）"
    echo "  -u, --update   仅更新镜像和配置文件"
    echo ""
    echo "示例:"
    echo "  $0              # 正常部署"
    echo "  $0 --force      # 强制重新部署"
    echo "  $0 --update     # 仅更新"
}

# 主函数
main() {
    local force_deploy=false
    local update_only=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -f|--force)
                force_deploy=true
                shift
                ;;
            -u|--update)
                update_only=true
                shift
                ;;
            *)
                print_error "未知参数: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    echo "🚀 FlyShadow Agent 一键部署脚本"
    echo "=================================="
    echo ""
    
    # 检查依赖
    check_docker
    check_network
    
    # 下载配置文件
    download_compose
    
    # 创建配置文件
    create_config
    
    # 拉取镜像
    pull_image
    
    if [ "$update_only" = true ]; then
        print_message "✅ 更新完成"
        exit 0
    fi
    
    # 清理旧容器（如果需要）
    if [ "$force_deploy" = true ]; then
        cleanup_old_container
    fi
    
    # 启动服务
    start_service
    
    # 检查状态
    check_status
}

# 运行主函数
main "$@" 