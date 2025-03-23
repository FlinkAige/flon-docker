source $1
# Default values for build parameters
VERSION=${VERSION:-"0.5.0-alpha"}

docker build -t build-flon-deb:${VERSION} . --no-cache
