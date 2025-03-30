#!/bin/bash
if [ -f ~/flon.env ]; then
  source ~/flon.env
fi

source ./env


set_ports() {
    local prefix=$1
    P2P_PORT="${prefix}${P2P_PORT}"
    RPC_PORT="${prefix}${RPC_PORT}"
    HIST_WS_PORT="${prefix}${HIST_WS_PORT}"
}

case "$NET" in
    "mainnet") ;;  # 默认端口
    "testnet") set_ports "1" ;;  # 端口加前缀 1
    "devnet")  set_ports "2" ;;  # 端口加前缀 2
    *) echo "Unknown network type: $NET"; exit 1 ;;
esac



NET=${NET}
VERSION=${VERSION}

# 动态生成的端口
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
POSTGRES_PORT=${POSTGRES_PORT} > ./env.processed

docker-compose --env-file $1 --env-file ./env.processed up -d
source ./env.processed
sudo iptables -I INPUT -p tcp -m tcp --dport "${POSTGRES_PORT}" -j ACCEPT