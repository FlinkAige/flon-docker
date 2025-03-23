
source $1

docker run -d --name flon-build -v /opt/data:/mnt build-flon-deb:$VERSION tail -f /dev/null