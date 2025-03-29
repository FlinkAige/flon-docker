docker cp ./devnet flon_wal:/root/
docker exec -it flon_wal bash -c "cd ~/devnet && ./run.init.chain.sh \"$1\""