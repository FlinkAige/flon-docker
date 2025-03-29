#!/bin/bash
set -euo pipefail  # 更严格的错误处理

# 配置部分
readonly NOD_DIR="${1:?请指定节点目录作为参数}/fuwal"
readonly ENV_FILE="./.env"
readonly USER_ENV_FILE="$HOME/flon.env"

# 加载环境变量
set -a
if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
fi

if [[ -f "$USER_ENV_FILE" ]]; then
    source "$USER_ENV_FILE"
    NODE_IMG_VER="${VERSION:-latest}"  # 设置默认值
fi
set +a

# 创建目录结构
mkdir -p "${NOD_DIR}"/{bin,conf,data,logs,bin-script}

# 复制文件
cp -v ./bin/run-wallet.sh "$NOD_DIR/bin/"
cp -v ./bin/.bashrc "$NOD_DIR/bin/"
cp -v ./config.ini "$NOD_DIR/conf/"
cp -vr ./bin-script/ "$NOD_DIR/"

# 设置权限
chmod -v +x "$NOD_DIR/bin/run-wallet.sh"

# 启动Docker容器
echo "正在启动Docker容器..."
if docker-compose up -d; then
    echo "Docker容器启动成功"
else
    echo "Docker容器启动失败" >&2
    exit 1
fi

# 注释掉的iptables规则（保留供参考）
# echo "如需开放端口7777，请取消以下行的注释:"
# echo "# sudo iptables -I INPUT -p tcp --dport 7777 -j ACCEPT"