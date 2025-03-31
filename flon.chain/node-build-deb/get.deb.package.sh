#!/bin/bash

if [ -f ~/flon.env ]; then
    source ~/flon.env
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IMG=${NODE_IMG_HEADER}fullon/funod:${VERSION}
package_name="fullon"
packages_dir="${SCRIPT_DIR}/deb"

cmds='
echo "deb http://mirrors.aliyun.com/ubuntu/ jammy main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list && \
apt update && apt install -y dpkg-repack;
mkdir -p /packages && cd /packages; 
dpkg-repack '${package_name}'
'

mkdir -p "${packages_dir}"
docker run -it --rm -v "${packages_dir}:/packages" $IMG bash -c "$cmds"


ossutil -e $PROD_OSS_ENDPOINT -i $ALI_OSS_ACCESS_KEY -k $ALI_OSS_ACCESS_SECRET cp