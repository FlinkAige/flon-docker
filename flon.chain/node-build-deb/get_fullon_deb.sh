
if [ -f ~/flon.env ]; then
    source ~/flon.env
fi
IMG=${NODE_IMG_HEADER}fullon/funod:${VERSION}
package_name="fullon"
bash -x ./get.deb.package.sh $IMG $package_name
