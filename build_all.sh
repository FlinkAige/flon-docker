
HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $HOME_DIR/flon.chain/node-build/
./build.sh
./docker_push.sh

cd $HOME_DIR/flon.cdt
./build-cdt-docker.sh
./docker_push.sh


cd $HOME_DIR/flon.scan/docker-build/
./build.sh
./docker_push.sh


