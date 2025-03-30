#!/bin/bash
# 加载基础配置
source .env

# 设置网络前缀
case "${NET}" in
    "mainnet") prefix="" ;;
    "testnet") prefix="1" ;;
    "devnet")  prefix="2" ;;
    *) echo "Error: Unknown NET type '${NET}'" >&2; exit 1 ;;
esac

# 应用端口前缀
export P2P_PORT="${prefix}${P2P_PORT}"
export RPC_PORT="${prefix}${RPC_PORT}"
export HIST_WS_PORT="${prefix}${HIST_WS_PORT}"
export NODE_PORT="${prefix}${NODE_PORT}"

# 生成容器名称后缀
export NETWORK_SUFFIX=$([ "$NET" != "mainnet" ] && echo "_${NET}" || echo "")