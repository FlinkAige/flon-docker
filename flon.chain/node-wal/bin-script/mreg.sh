creator=$1
acct=$2
pubkey=$3

fucli -u $murl system newaccount $creator $acct $pubkey --transfer-quant "5.00000000 FLON" -p $creator
