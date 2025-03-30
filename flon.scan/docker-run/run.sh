#!/bin/bash
set -euo pipefail  # 启用严格模式
# 日志函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1"
}

error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >&2
    exit 1
}

# 网络配置
configure_network() {
    case "${NET}" in
        "mainnet") 
            prefix=""
            ;;
        "testnet")
            prefix="1"
            ;;
        "devnet")
            prefix="2"
            ;;
        *) 
            error "Unsupported network type: ${NET}"
            ;;
    esac

    export POSTGRES_PORT="${prefix}${POSTGRES_PORT}"
    export NODE_PORT="${prefix}${NODE_PORT}"
    
    log "Network ports configured: POSTGRES_PORT=${POSTGRES_PORT}, NODE_PORT=${NODE_PORT}"
}

# 生成环境文件
generate_env_file() {
    local output_file="./env.processed"
    
    cat <<EOF > "${output_file}"
# Auto-generated configuration - $(date '+%Y-%m-%d %H:%M:%S')
# Network Configuration
NET=${NET}
VERSION=${VERSION}

# Port Configuration
NODE_PORT=${NODE_PORT}
NODE_HOST=${NODE_HOST}

# Database Configuration
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_PORT=${POSTGRES_PORT}
POSTGRES_CONTAINER_NAME=${POSTGRES_CONTAINER_NAME_HEADER}_${NET}
SCAN_CONTAINER_NAME=${SCAN_CONTAINER_NAME_HEADER}_${NET}
PG_DATA=${PG_DATA_HEADER}_${NET}

# Service Configuration
HISTORY_TOOLS_IMAGE=${NODE_IMG_HEADER}${HISTORY_TOOLS_IMAGE}:${VERSION}

FILL_TABLES=${FILL_TABLES}
CREATE_TABLE=${CREATE_TABLE}
EOF

    log "Generated environment file: ${output_file}"
}


# 启动服务
start_services() {
    local compose_args=("--env-file=./env.processed")
    
    if [ $# -gt 0 ] && [ -f "$1" ]; then
        log "Using additional environment file: $1"
        compose_args+=("--env-file=$1")
    fi

    log "Starting Docker services"
    docker-compose "${compose_args[@]}" up -d || \
        error "Failed to start services"
}

main() {
     # 加载环境变量
    [ -f ~/flon.env ] && source ~/flon.env
    [ -f ./env ] && source ./env

    configure_network

    generate_env_file
    start_services "$@"
    log "Deployment completed successfully"
}

main "$@"