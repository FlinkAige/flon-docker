creator=$1
acct=$2
pubkey=$3

amcli -u $turl system newaccount $creator --transfer $acct $pubkey \
    --stake-net "0.1 AMAX" --stake-cpu "0.1 AMAX" --buy-ram-kbytes 4 \
    -p ${creator}@active
