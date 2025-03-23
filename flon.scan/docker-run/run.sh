#!/bin/bash

export $(grep -v '^#' $1 | xargs)

envsubst < ./env > ./env.processed

docker-compose --env-file $1 --env-file ./.env.processed up -d

rm -rf ./.env.processed