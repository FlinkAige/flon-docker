#!/bin/bash

if [ -f ~/flon.env ]; then
    source ~/flon.env
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IMG=${NODE_IMG_HEADER}fullon/funod:${VERSION}
package_name="fullon.install.deb"
packages_dir="${SCRIPT_DIR}/.test"

cmds='
apt update && apt install -y dpkg-repack;
mkdir -p /packages && cd /packages;
dpkg-repack '${package_name}');
'

mkdir -p "${packages_dir}"
docker run -it --rm -v "${packages_dir}:/packages" $IMG bash -c "$cmds"