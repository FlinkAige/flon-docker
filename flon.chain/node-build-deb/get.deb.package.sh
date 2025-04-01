#!/bin/bash

if [ -f ~/flon.env ]; then
    source ~/flon.env
fi

DEB_PATH=$(realpath ~/deb)
IMG=$1
package_name=$2

rm -rf $DEB_PATH

cmds='
echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
apt update && apt install -y dpkg-repack;
mkdir -p /packages && cd /packages; 
dpkg-repack '${package_name}'
'

mkdir -p "${DEB_PATH}"
docker run -it --rm -v "${DEB_PATH}:/packages" $IMG bash -c "$cmds"

ossutil cp -f ${DEB_PATH}/* oss://flon-test/deb/