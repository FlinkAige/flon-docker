#!/bin/bash

# Set log file location
HOME_DIR=$HOME
LOG_FILE="$HOME_DIR/build_and_deploy.log"

# Function to log messages with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Parse arguments
BUILD_CHAIN=false
BUILD_CDT=false
BUILD_SCAN=false
BUILD_DEB=false

for arg in "$@"; do
    case $arg in
        chain) BUILD_CHAIN=true ;;
        cdt) BUILD_CDT=true ;;
        scan) BUILD_SCAN=true ;;
        deb) BUILD_DEB=true ;;
        all) BUILD_CHAIN=true; BUILD_CDT=true; BUILD_SCAN=true; BUILD_DEB=true ;;
        *) echo "Unknown option: $arg"; exit 1 ;;
    esac
done

# If no options provided, build all
if [ "$#" -eq 0 ]; then
    BUILD_CHAIN=true
    BUILD_CDT=true
    BUILD_SCAN=true
    BUILD_DEB=true
fi

echo ${BUILD_CHAIN}
echo ${BUILD_CDT}
echo ${BUILD_SCAN}
echo ${BUILD_DEB}

# Start of process
log "Starting build and deployment process"
HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
log "Home directory: $HOME_DIR"

# Build flon.chain
if [ "$BUILD_CHAIN" = true ]; then
    log "Building flon.chain node..."
    cd "$HOME_DIR/flon.chain/node-build/" || { log "Error: Failed to cd to flon.chain/node-build"; exit 1; }
    ./build.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.chain build.sh failed"; exit 1; }
    ./docker_push.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.chain docker_push.sh failed"; exit 1; }
    log "flon.chain node build and push completed successfully"
fi

# Build flon.cdt
if [ "$BUILD_CDT" = true ]; then
    log "Building flon.cdt..."
    cd "$HOME_DIR/flon.cdt" || { log "Error: Failed to cd to flon.cdt"; exit 1; }
    ./build-cdt-docker.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.cdt build-cdt-docker.sh failed"; exit 1; }
    ./docker_push.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.cdt docker_push.sh failed"; exit 1; }
    log "flon.cdt build and push completed successfully"
fi

# Build flon.scan
if [ "$BUILD_SCAN" = true ]; then
    log "Building flon.scan..."
    cd "$HOME_DIR/flon.scan/docker-build/" || { log "Error: Failed to cd to flon.scan/docker-build"; exit 1; }
    ./build.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.scan build.sh failed"; exit 1; }
    ./docker_push.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.scan docker_push.sh failed"; exit 1; }
    log "flon.scan build and push completed successfully"
fi

# Generate and upload DEB packages
if [ "$BUILD_DEB" = true ]; then
    log "Generating and uploading DEB packages..."
    cd "$HOME_DIR/flon.chain/node-build-deb/" || { log "Error: Failed to cd to flon.chain/node-build-deb"; exit 1; }
    ./get_fullon_cdt_deb.sh >> "$LOG_FILE" 2>&1 || { log "Error: get_fullon_cdt_deb.sh failed"; exit 1; }
    ./get_fullon_deb.sh >> "$LOG_FILE" 2>&1 || { log "Error: get_fullon_deb.sh failed"; exit 1; }
    log "DEB package generation and upload completed successfully"
fi

log "All selected build and deployment processes completed successfully"
