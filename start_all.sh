#!/bin/bash

# Set log file location
LOG_FILE="$HOME_DIR/start_all.log"



cd $HOME_DIR/flon.chain/node-run
# Function to log messages with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}
# Start of process
./1-setup-node-env.sh >> "$LOG_FILE" 2>&1 || { log "Error: 1-setup-node-env.sh failed"; exit 1; }   

sleep 1
cd $HOME_DIR/.funod_testnet