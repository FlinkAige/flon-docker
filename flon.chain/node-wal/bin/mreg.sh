creator=$1
acct=$2
pubkey=$3

amcli -u $murl system newaccount $creator  $acct $pubkey \
    --stake-net "0.005 AMAX" --stake-cpu "0.005 AMAX" --buy-ram-kbytes 4 \
    -p ${creator}@active
