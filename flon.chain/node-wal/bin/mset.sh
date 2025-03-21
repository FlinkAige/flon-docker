con=$1
condir=$2

focli -u $murl set contract $con ./build/contracts/$condir -p ${con}@active
