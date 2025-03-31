#!/bin/bash

# Load variables from the .env.upload file
if [ -f ~/flon.env ]; then
  source ~/flon.env
else 
  echo "Error: ~/flon.env file not found!"
  exit 1
fi
IMAGE_NAME="fullon/funod"
#  FlinkAige fullon/funod 0.5.8-alpha
bash -x ../../commtool/docker_upload.sh $GITHUB_USERNAME $IMAGE_NAME $VERSION