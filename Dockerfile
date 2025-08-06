# 使用多阶段构建，支持不同架构
FROM --platform=$BUILDPLATFORM alpine:latest AS base

# 设置工作目录
WORKDIR /app

# 复制二进制文件到容器中
COPY agent\(x64\) /app/agent-x64
COPY agent\(ARM\) /app/agent-arm

# 创建启动脚本，根据架构选择相应的二进制文件
RUN echo '#!/bin/sh' > /app/start.sh && \
    echo 'case "$(uname -m)" in' >> /app/start.sh && \
    echo '    x86_64|amd64)' >> /app/start.sh && \
    echo '        cp /app/agent-x64 /app/agent' >> /app/start.sh && \
    echo '        chmod +x /app/agent' >> /app/start.sh && \
    echo '        exec /app/agent run' >> /app/start.sh && \
    echo '        ;;' >> /app/start.sh && \
    echo '    aarch64|arm64|arm)' >> /app/start.sh && \
    echo '        cp /app/agent-arm /app/agent' >> /app/start.sh && \
    echo '        chmod +x /app/agent' >> /app/start.sh && \
    echo '        exec /app/agent run' >> /app/start.sh && \
    echo '        ;;' >> /app/start.sh && \
    echo '    *)' >> /app/start.sh && \
    echo '        echo "Unsupported architecture: $(uname -m)"' >> /app/start.sh && \
    echo '        exit 1' >> /app/start.sh && \
    echo '        ;;' >> /app/start.sh && \
    echo 'esac' >> /app/start.sh && \
    chmod +x /app/start.sh

# 暴露端口9999
EXPOSE 9999

# 设置启动命令
CMD ["/app/start.sh"] 