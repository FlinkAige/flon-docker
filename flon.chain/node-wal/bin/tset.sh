con=$1
condir=$2

amcli -u $turl set contract $con ./build/contracts/$condir -p ${con}@active
