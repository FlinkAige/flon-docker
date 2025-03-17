#!/bin/bash
source $1
# Default values for build parameters
DOCKER_IMG=${DOCKER_IMG:-"fullon/history-tools"}
VERSION=${VERSION:-"0.5.0-alpha"}
BRANCH=${BRANCH:-"main"}
REPO=${REPO:-"https://github.com/fullon-labs/history-tools.git"}

# Build the Docker image
docker build -t ${DOCKER_IMG}:${VERSION} \
  --build-arg BRANCH=${BRANCH} \
  --build-arg REPO=${REPO} \
  --no-cache \
  $@ .