export murl='http://hk-m1.nchain.me:8888'
export turl='http://hk-t3.vmi.nestar.vip:28888'
export walname='flontest'

alias unlockt="fucli wallet unlock -n $walname --password $(< ~/.password.txt)"
alias macct="fucli -u $murl get account"
alias mcli="fucli -u $murl"
alias mtbl='fucli -u $murl get table'
alias mtran='fucli -u $murl transfer'
alias mpush='fucli -u $murl push action'
alias tcli='fucli -u $turl'
alias ttbl='fucli -u $turl get table'
alias ttran='fucli -u $turl transfer'
alias tpush='fucli -u $turl push action'
alias pki="fucli wallet import -n ${walname} --private-key "
alias treg='bash ~/bin/treg.sh'
alias mreg='bash ~/bin/mreg.sh'
alias tset='bash ~/bin/tset.sh'
alias mset='bash ~/bin/mset.sh'
alias tnew='bash ~/bin/tnew.sh'

