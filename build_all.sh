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
DO_BUILD=false
DO_PUSH=false

for arg in "$@"; do
    case $arg in
        chain) BUILD_CHAIN=true ;;
        cdt) BUILD_CDT=true ;;
        scan) BUILD_SCAN=true ;;
        deb) BUILD_DEB=true ;;
        build) DO_BUILD=true ;;
        push) DO_PUSH=true ;;
        build_push|bp) DO_BUILD=true; DO_PUSH=true ;;
        all) 
            BUILD_CHAIN=true
            BUILD_CDT=true
            BUILD_SCAN=true
            BUILD_DEB=true
            DO_BUILD=true
            DO_PUSH=true
            ;;
        *) echo "Unknown option: $arg"; exit 1 ;;
    esac
done

# If no options provided, default to build and push all
if [ "$#" -eq 0 ]; then
    BUILD_CHAIN=true
    BUILD_CDT=true
    BUILD_SCAN=true
    BUILD_DEB=true
    DO_BUILD=true
    DO_PUSH=true
fi

log "Starting build and deployment process"
HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
log "Home directory: $HOME_DIR"

# Build and/or push flon.chain
if [ "$BUILD_CHAIN" = true ]; then
    log "Processing flon.chain..."
    cd "$HOME_DIR/flon.chain/node-build/" || { log "Error: Failed to cd to flon.chain/node-build"; exit 1; }

    if [ "$DO_BUILD" = true ]; then
        log "Building flon.chain node..."
        ./build.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.chain build.sh failed"; exit 1; }
        log "flon.chain node build completed successfully"
    fi

    if [ "$DO_PUSH" = true ]; then
        log "Pushing flon.chain node image..."
        ./docker_push.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.chain docker_push.sh failed"; exit 1; }
        log "flon.chain node image push completed successfully"
    fi
fi

# Build and/or push flon.cdt
if [ "$BUILD_CDT" = true ]; then
    log "Processing flon.cdt..."
    cd "$HOME_DIR/flon.cdt" || { log "Error: Failed to cd to flon.cdt"; exit 1; }

    if [ "$DO_BUILD" = true ]; then
        log "Building flon.cdt..."
        ./build-cdt-docker.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.cdt build-cdt-docker.sh failed"; exit 1; }
        log "flon.cdt build completed successfully"
    fi

    if [ "$DO_PUSH" = true ]; then
        log "Pushing flon.cdt image..."
        ./docker_push.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.cdt docker_push.sh failed"; exit 1; }
        log "flon.cdt image push completed successfully"
    fi
fi

# Build and/or push flon.scan
if [ "$BUILD_SCAN" = true ]; then
    log "Processing flon.scan..."
    cd "$HOME_DIR/flon.scan/docker-build/" || { log "Error: Failed to cd to flon.scan/docker-build"; exit 1; }

    if [ "$DO_BUILD" = true ]; then
        log "Building flon.scan..."
        ./build.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.scan build.sh failed"; exit 1; }
        log "flon.scan build completed successfully"
    fi

    if [ "$DO_PUSH" = true ]; then
        log "Pushing flon.scan image..."
        ./docker_push.sh >> "$LOG_FILE" 2>&1 || { log "Error: flon.scan docker_push.sh failed"; exit 1; }
        log "flon.scan image push completed successfully"
    fi
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
