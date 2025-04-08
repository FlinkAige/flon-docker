#!/bin/bash

[ ! -f ./node.env ] && echo "Error: node.env file not found. Exiting..." && exit 1

set -a
source ./node.env
set +a
err() {
    echo "$(tput setaf 1)$1$(tput sgr0)"
    exit 1
}

check_port_with_prompt() {
    local port=$1
    if sudo netstat -tulnp | grep -q ":$port "; then
        echo -e "\033[31mERROR: Port $port is already in use.\033[0m" >&2
        read -p "Do you want to continue anyway? (y/N) " answer
        case "$answer" in
            [yY]|[yY][eE][sS])
                echo "Continuing despite port conflict..."
                return 0
                ;;
            *)
                echo "Aborting..."
                exit 1
                ;;
        esac
    fi
}

check_docker_exists() {
    contaner_name=$1
    if docker ps -a | grep -q "$contaner_name"; then
        echo "Docker 容器 $contaner_name 已经存在"
        read -p "Do you want to continue anyway? (y/N) " answer
        case "$answer" in
            [yY]|[yY][eE][sS])
                echo "Continuing despite container conflict..."
                return 0
                ;;
            *)
                echo "Aborting..."
                exit 1
                ;;
        esac
    fi
}

check_port_with_prompt "${RPC_PORT}"
check_docker_exists ${node_name}

# Define destination directories
DEST_CONF="${NODE_WORK_PTAH}/conf/config.ini"

# Create necessary directories
mkdir -p "$NODE_WORK_PTAH"/{conf,data,logs}

# Copy files to destination
cp -r ./bin "$NODE_WORK_PTAH/" && \
cp ./genesis.json "$NODE_WORK_PTAH/conf/" && \
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