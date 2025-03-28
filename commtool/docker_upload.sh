#!/bin/bash
# docker-push.sh - Docker 镜像标签和推送工具

set -euo pipefail  # 启用严格模式

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 帮助函数
usage() {
  echo -e "${GREEN}Usage: $0 <github-username> <image-name> <version> [repository-name]${NC}"
  echo -e "Example:"
  echo -e "  $0 myusername floncdt v1.2.3 fullon"
  echo -e "  $0 myusername nginx latest"
  exit 1
}

# 检查参数数量
if [ $# -lt 3 ]; then
  echo -e "${RED}Error: Missing required parameters!${NC}"
  usage
fi

# 参数赋值
GITHUB_USERNAME="$1"
IMAGE_NAME="$2"
VERSION="$3"

# 规范化用户名（小写）
GITHUB_USERNAME_LOWER=$(echo "$GITHUB_USERNAME" | tr '[:upper:]' '[:lower:]')

# 获取镜像ID
echo -e "${YELLOW}Looking for image $IMAGE_NAME:$VERSION...${NC}"
IMAGE_ID=$(docker images -q "$IMAGE_NAME:$VERSION")

if [ -z "$IMAGE_ID" ]; then
  echo -e "${RED}Error: Image $IMAGE_NAME:$VERSION not found locally!${NC}"
  echo "Available images:"
  docker images | grep "$IMAGE_NAME" || echo "No matching images found"
  exit 1
fi

# Docker 登录
echo -e "${YELLOW}Logging into GitHub Container Registry...${NC}"
if [ ! -f ~/ghcr.txt ]; then
  echo -e "${RED}Error: Docker login credentials file ~/ghcr.txt not found!${NC}"
  exit 1
fi

cat ~/ghcr.txt | docker login ghcr.io -u "$GITHUB_USERNAME" --password-stdin || {
  echo -e "${RED}Error: Docker login failed!${NC}"
  exit 1
}

# 构建目标镜像名称
TARGET_IMAGE="ghcr.io/${GITHUB_USERNAME_LOWER}/${IMAGE_NAME}:${VERSION}"

# 添加标签
echo -e "${YELLOW}Tagging image $IMAGE_ID as $TARGET_IMAGE...${NC}"
docker tag "$IMAGE_ID" "$TARGET_IMAGE" || {
  echo -e "${RED}Error: Failed to tag image!${NC}"
  exit 1
}

echo -e "${GREEN}Successfully tagged image: $TARGET_IMAGE${NC}"

# 推送镜像
echo -e "${YELLOW}Pushing image to GitHub Container Registry...${NC}"
docker push "$TARGET_IMAGE" || {
  echo -e "${RED}Error: Failed to push image!${NC}"
  exit 1
}

echo -e "${GREEN}Successfully pushed image: $TARGET_IMAGE${NC}"
echo -e "${GREEN}Done!${NC}"

exit 0
