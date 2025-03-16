#!/bin/bash

# Load variables from the .env file
if [ -f env.upload ]; then
  export $(cat env.upload | xargs)
else
  echo "Error: env.upload file not found!"
  exit 1
fi
TAG=$1
IMAGE_ID=$(docker images -q $IMAGE_NAME:$TAG)

# Check if required variables are defined
if [ -z "$IMAGE_ID" ] || [ -z "$GITHUB_USERNAME" ] || [ -z "$REPO_NAME" ] || [ -z "$IMAGE_NAME" ] || [ -z "$TAG" ]; then
  echo "Error: Missing required parameters !"
  exit 1
fi

# Execute the docker tag command
docker tag $IMAGE_ID ghcr.io/$GITHUB_USERNAME/$REPO_NAME/$IMAGE_NAME:$TAG

# Check if the command was successful
if [ $? -eq 0 ]; then
  echo "Image tag successfully added: ghcr.io/$GITHUB_USERNAME/$REPO_NAME/$IMAGE_NAME:$TAG"
else
  echo "Failed to add image tag!"
  exit 1
fi