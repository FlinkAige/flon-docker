name=$1
creator=flon

unlockt
ret=`tcli create key --to-console`
echo "create key: $ret"
privKey=${ret:13:51}
pubKey=`echo $ret | sed -n '1p'`
pubKey=${pubKey:0-52:52}
echo "privKey: $privKey"
echo "pubKey: $pubKey"
pki ${privKey}


amcli -u $turl system newaccount $creator $name $pubkey --transfer-quant "5.00000000 FLON" -p $creator