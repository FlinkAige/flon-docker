
focli wallet create -f ~/.password.txt -n test
focli wallet unlock -n test --password $(< ~/.password.txt)

#flon
focli wallet import -n test --private-key 5K4Bjy3ZWUUUrTbUKANcx13fgY3kXWUDtwYTDQhu7v1ALvrmAAK

focli  wallet create_key --to-console

#FO8ixPk3x4wZQu1bwBtw67JznFr5LVcA9bfDpkS7grnms3JNm7Qq
focli wallet import -n test --private-key 5JvRuaZBiFC1Bm95tmGP4feduY3BuWqqpqrjo8CJBFPGy26YjXc

user1=vest.1
tcli system newaccount flon $user1 FO8ixPk3x4wZQu1bwBtw67JznFr5LVcA9bfDpkS7grnms3JNm7Qq  --transfer-quant "5.000000 FLON" -p flon

tcli system newaccount flon abc FO8ixPk3x4wZQu1bwBtw67JznFr5LVcA9bfDpkS7grnms3JNm7Qq  --transfer-quant "9.000000 FLON" -p flon
tcli system newaccount flon abd FO8ixPk3x4wZQu1bwBtw67JznFr5LVcA9bfDpkS7grnms3JNm7Qq  --transfer-quant "9.000000 FLON" -p flon


tcli push action flon.token transfer '["abc", "abd","1.00000000 FLON", ""]' -p abc


tcli get table flon.token abc accounts
tcli get table flon.token abd accounts

con=vest.1
condir=flon.vest
tcli set contract $con ./build/contracts/$condir -p ${con}@active
tcli get transaction $txid



