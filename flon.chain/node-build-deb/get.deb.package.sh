#!/bin/bash

# 设置日志文件
LOG_FILE="$HOME/build_deploy_report.log"

# 写入日志的函数
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 加载环境变量
if [ -f ~/flon.env ]; then
    source ~/flon.env
fi

DEB_PATH=$(realpath ~/deb)
IMG=$1
package_name=$2

# 检查是否提供了镜像和包名
if [ -z "$IMG" ] || [ -z "$package_name" ]; then
    log "Error: Missing required parameters (image-name or package-name)"
    echo "Usage: $0 <image-name> <package-name>"
    exit 1
fi

log "Starting process to repackage .deb and upload to OSS..."

# 删除旧的 deb 包目录
log "Cleaning up previous deb directory..."
rm -rf $DEB_PATH

# 准备安装命令
cmds='
echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
apt update && apt install -y dpkg-repack;

# 创建并进入 /packages 目录
mkdir -p /packages && cd /packages;

# 打包指定的包
dpkg-repack '${package_name}'
'

# 创建目标目录
mkdir -p "${DEB_PATH}"

# 通过 Docker 执行命令
log "Running Docker container to repackage .deb package..."
docker run -it --rm -v "${DEB_PATH}:/packages" $IMG bash -c "$cmds" || {
    log "Error: Docker command failed during .deb packaging"
    echo "Error: Docker command failed during .deb packaging"
    exit 1
}

log "Successfully repacked .deb package: $package_name"

# 上传到阿里云 OSS
log "Uploading .deb packages to OSS..."
ossutil cp -f ${DEB_PATH}/* oss://flon-test/deb/ || {
    log "Error: Failed to upload .deb packages to OSS"
    echo "Error: Failed to upload .deb packages to OSS"
    exit 1
}

log "Successfully uploaded .deb packages to OSS."

# 获取最新上传的 .deb 包并生成 HTTP URL
latest_file=$(ls -t ${DEB_PATH}/* | head -n 1)  # 获取最新上传的文件
if [ -n "$latest_file" ]; then
    deb_file_name=$(basename "$latest_file")
    http_url="https://flon-test.oss-cn-shanghai.aliyuncs.com/deb/$deb_file_name"
    log "Latest .deb package download URL: $http_url"
    echo "Download URL: $http_url"  # 输出到控制台，便于查看
else
    log "Error: No .deb package found for uploading."
    exit 1
fi

log "Process completed successfully. All tasks done!"
