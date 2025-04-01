#!/bin/bash

if [ -f ~/flon.env ]; then
    source ~/flon.env
fi
IMG=${NODE_IMG_HEADER}fullon/floncdt:${CDT_VERSION}
package_name="fullon"