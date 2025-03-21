con=$1
condir=$2

focli -u $turl set contract $con ./build/contracts/$condir -p ${con}@active
