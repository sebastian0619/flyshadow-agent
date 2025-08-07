#!/bin/bash

# FlyShadow Agent 一键部署脚本
# 支持从命令行传入密码和节点ID

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# 显示帮助信息
show_help() {
    echo "FlyShadow Agent 一键部署脚本"
    echo ""
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  -h, --help             显示此帮助信息"
    echo "  -p, --password PASS    指定Agent密码"
    echo "  -n, --node-id ID       指定节点ID"
    echo "  -f, --force            强制重新部署"
    echo "  -u, --update           仅更新"
    echo ""
    echo "示例:"
    echo "  $0 -p mypassword -n mynode123"
    echo "  $0 -p mypassword -n mynode123 --force"
    echo ""
    echo "一键部署命令:"
    echo "  curl -fsSL https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/deploy.sh | FLYSHADOW_PASSWORD=mypass FLYSHADOW_NODE_ID=mynode bash"
}

# 主函数
main() {
    local password=""
    local node_id=""
    local force_deploy=false
    local update_only=false
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -p|--password)
                password="$2"
                shift 2
                ;;
            -n|--node-id)
                node_id="$2"
                shift 2
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
    
    # 检查必需参数
    if [ -z "$password" ]; then
        print_error "请指定密码 (-p 或 --password)"
        show_help
        exit 1
    fi
    
    if [ -z "$node_id" ]; then
        print_error "请指定节点ID (-n 或 --node-id)"
        show_help
        exit 1
    fi
    
    print_step "开始一键部署 FlyShadow Agent..."
    
    # 构建部署命令
    local deploy_cmd="curl -fsSL https://raw.githubusercontent.com/sebastian0619/flyshadow-agent/main/deploy.sh"
    
    if [ "$force_deploy" = true ]; then
        deploy_cmd="$deploy_cmd | FLYSHADOW_PASSWORD=\"$password\" FLYSHADOW_NODE_ID=\"$node_id\" bash -s -- --force"
    elif [ "$update_only" = true ]; then
        deploy_cmd="$deploy_cmd | FLYSHADOW_PASSWORD=\"$password\" FLYSHADOW_NODE_ID=\"$node_id\" bash -s -- --update"
    else
        deploy_cmd="$deploy_cmd | FLYSHADOW_PASSWORD=\"$password\" FLYSHADOW_NODE_ID=\"$node_id\" bash"
    fi
    
    print_message "执行命令: $deploy_cmd"
    echo ""
    
    # 执行部署
    eval "$deploy_cmd"
}

# 运行主函数
main "$@"
