#!/bin/bash

if [ -f ~/flon.env ]; then
    source ~/flon.env
fi
IMG=${NODE_IMG_HEADER}fullon/floncdt:${CDT_VERSION}
package_name="fullon"

bash -x ./get_fullon_deb.sh $IMG $package_name