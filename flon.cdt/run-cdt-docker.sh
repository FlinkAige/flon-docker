IMG=$1
[ -z "$IMG" ] && IMG=localhost/build-flon-deb:1.0.1

docker run -it --name flon-build $IMG bash
