#!/bin/bash
if [ -f ~/flon.env ]; then
  source ~/flon.env
fi

export $(grep -v '^#' $1 | xargs)

envsubst < ./env > ./env.processed


docker-compose --env-file $1 --env-file ./env.processed up -d
source ./env.processed
sudo iptables -I INPUT -p tcp -m tcp --dport "${POSTGRES_PORT}" -j ACCEPT