#!/bin/bash

[ ! -f ./node.env ] && echo "Error: node.env file not found. Exiting..." && exit 1

set -a
source ./node.env
set +a

sudo yum install lsof -y

#CHECK 端口是否被占用
check_port() {
    local port=$1
    if [ -z "$port" ]; then
        echo "Error: Port number not provided."
        exit 1
    fi
    if ! command -v netstat >/dev/null; then
        echo "Error: 'netstat' command not installed. Please install net-tools package."
        exit 1
    fi
    if sudo netstat -tulnp | grep -q ":$port "; then
        echo "Port $port is in use."
        exit 1
    else
        echo "Port $port is available."
    fi
}

check_port "${P2P_PORT}"
check_port "${RPC_PORT}"
check_port "${HIST_WS_PORT}"


# Define destination directories
DEST_CONF="${NODE_WORK_PAHT}/conf/config.ini"

# Create necessary directories
mkdir -p "$NODE_WORK_PAHT"/{conf,data,logs}

# Copy files to destination
cp -r ./bin "$NODE_WORK_PAHT/" && \
cp ./genesis.json "$NODE_WORK_PAHT/conf/" && \
cp ./conf/base.ini "$DEST_CONF"

# Append node configuration to config.ini
append_config() {
    echo -e "\n#### $1" >> "$DEST_CONF"
    cat "$2" >> "$DEST_CONF"
}

# Replace placeholders in config.ini
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i "" "s/agent_name/${agent_name}/g" "$DEST_CONF"
  sed -i "" "s/p2p_server_address/${p2p_server_address}/g" "$DEST_CONF"
  sed -i "" "s/P2P_PORT/${P2P_PORT}/g" "$DEST_CONF"
else
  sed -i "s/agent_name/${agent_name}/g" "$DEST_CONF"
  sed -i "s/p2p_server_address/${p2p_server_address}/g" "$DEST_CONF"
  sed -i "s/P2P_PORT/${P2P_PORT}/g" "$DEST_CONF"
fi

# Add p2p peer addresses if they exist
if [ -n "${p2p_peer_addresses}" ]; then
    for peer in "${p2p_peer_addresses[@]}"; do
        echo "p2p-peer-address = $peer" >> "$DEST_CONF"
    done
fi

# Append plugin configurations if enabled
if [ "${trace_plugin}" == "true" ]; then
    append_config "Trace plugin conf:" "./conf/plugin_trace.ini"
fi

if [ "${history_plugin}" == "true" ]; then
    append_config "History plugin conf:" "./conf/plugin_history.ini"
fi

if [ "${state_plugin}" == "true" ]; then
    append_config "State plugin conf:" "./conf/plugin_state.ini"
fi

if [ "${bp_plugin}" == "true" ]; then
    append_config "Block producer plugin conf:" "./conf/plugin_bp.ini"
    for producer_name in "${producer_names[@]}"; do
        echo "producer-name = $producer_name" >> "$DEST_CONF"
    done
    for signature_provider in "${signature_providers[@]}"; do
        echo "signature-provider = $signature_provider" >> "$DEST_CONF"
    done
fi

# Create Docker network and start containers
docker network create flon || echo "Docker network 'flon' already exists or failed to create."
docker-compose --env-file ./node.env up -d

# Open firewall ports
open_port() {
    if [[ "$(uname)" == "Linux" ]]; then
        sudo iptables -I INPUT -p tcp -m tcp --dport "$1" -j ACCEPT
    fi
}

open_port "${RPC_PORT}"
open_port "${P2P_PORT}"
open_port "${HIST_WS_PORT}"

echo "Setup completed successfully!"