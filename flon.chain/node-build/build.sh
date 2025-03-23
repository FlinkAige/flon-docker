#!/bin/bash
source $1
if [ -z "~/flon.env" ]; then
  source ~/flon.env
fi
# Default values for build parameters
DOCKER_IMG=${DOCKER_IMG:-"fullon/funod"}
VERSION=${VERSION:-"0.5.0-alpha"}
BRANCH=${BRANCH:-"main"}
LOCAL_PATH=${LOCAL_PATH:-"../../"}
REPO=${REPO:-"https://github.com/fullon-labs/flon-core.git"}
MODE=${MODE:-"git"}

LOCAL_PATH=$(readlink -f "${LOCAL_PATH}")

# Build the Docker image
docker build -t ${DOCKER_IMG}:${VERSION} \
  --build-arg BRANCH=${BRANCH} \
  --build-arg REPO=${REPO} \
  --build-arg MODE=${MODE} \
  --build-arg LOCAL_PATH=${LOCAL_PATH} \
  --no-cache \
  .