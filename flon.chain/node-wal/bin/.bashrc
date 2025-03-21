export murl='http://hk-m1.nchain.me:8888'
export turl='http://hk-t1.nchain.me:18888'

alias unlockt='focli wallet unlock -n flontest --password $(< ~/.password.txt)'
alias macct="focli -u $murl get account"
alias mcli="focli -u $murl"
alias mtbl='focli -u $murl get table'
alias mtran='focli -u $murl transfer'
alias mpush='focli -u $murl push action'
alias tcli='focli -u $turl'
alias ttbl='focli -u $turl get table'
alias ttran='focli -u $turl transfer'
alias tpush='focli -u $turl push action'
alias pki='focli wallet import -n flontest --private-key '
alias treg='bash ~/bin/treg.sh'
alias mreg='bash ~/bin/mreg.sh'
alias tset='bash ~/bin/tset.sh'
alias mset='bash ~/bin/mset.sh'

