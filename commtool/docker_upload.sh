#!/bin/bash

GITHUB_USERNAME=$1
IMAGE_NAME=$2
VERSION=$3

IMAGE_ID=$(docker images -q $IMAGE_NAME:$VERSION)

cat ~/ghcr.txt | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin

# Check if required variables are defined
if [ -z "$IMAGE_ID" ] || [ -z "$GITHUB_USERNAME" ] || [ -z "$VERSION" ]; then
  echo "Error: Missing required parameters !"
  exit 1
fi

GITHUB_USERNAME=$(echo "$GITHUB_USERNAME" | tr '[:upper:]' '[:lower:]')
# Execute the docker tag command
docker tag $IMAGE_ID ghcr.io/${GITHUB_USERNAME}fullon/floncdt:$VERSION

# Check if the command was successful
if [ $? -eq 0 ]; then
  echo "Image tag successfully added: ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME:$VERSION"
else
  echo "Failed to add image tag!"
  exit 1
fi

docker push ghcr.io/$GITHUB_USERNAME/$IMAGE_NAME:$VERSION