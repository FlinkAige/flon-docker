#！/bin/bash

set -a
NOD_DIR=$1/flon
source ./.env
if [ -z "~/flon.env" ]; then
    source ~/flon.env
    NODE_IMG_VER=$VERSION
fi

mkdir -p $NOD_DIR/bin $NOD_DIR/conf $NOD_DIR/data $NOD_DIR/logs

cp ./bin/run-wallet.sh $NOD_DIR/bin/
cp ./bin/.bashrc $NOD_DIR/bin/
cp ./config.ini $NOD_DIR/conf/
chmod +x $NOD_DIR/bin/run-wallet.sh

docker-compose up -d

#sudo iptables -I INPUT -p tcp -m tcp --dport 7777 -j ACCEPT
