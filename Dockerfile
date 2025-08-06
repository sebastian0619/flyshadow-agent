# 使用多阶段构建，支持不同架构
FROM --platform=$BUILDPLATFORM alpine:latest AS base

# 设置工作目录
WORKDIR /app

# 定义构建参数
ARG TARGETARCH

# 根据架构复制对应的二进制文件
COPY agent\(x64\) /app/agent-x64
COPY agent\(ARM\) /app/agent-arm

# 根据目标架构选择二进制文件
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        cp /app/agent-x64 /app/agent; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        cp /app/agent-arm /app/agent; \
    else \
        echo "Unsupported architecture: $TARGETARCH"; \
        exit 1; \
    fi && \
    chmod +x /app/agent && \
    rm /app/agent-x64 /app/agent-arm

# 暴露端口9999
EXPOSE 9999

# 设置启动命令
CMD ["/app/agent", "run"] 