# 检查参数
if [ $# -eq 0 ]; then
    echo "错误：缺少初始化参数 节点地址" 
    exit 1
fi

docker cp ./devnet flon_wal:/root/
docker exec -it flon_wal bash -c "cd ~/devnet && ./run.init.chain.sh \"$1\""