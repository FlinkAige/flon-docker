#!/bin/bash
if [ -f ~/flon.env ]; then
  source ~/flon.env
fi

# Default values for build parameters
VERSION=${VERSION:-"0.5.0-alpha"}

docker build -t ${NODE_IMG_HEADER}fullon/floncdt:${VERSION} . --no-cache
