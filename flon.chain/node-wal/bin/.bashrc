source ~/bin/flonchain.env

alias newt="fucli wallet create -f ~/.password.txt -n $walname"
alias unlockt='fucli wallet unlock -n $walname --password $(< ~/.password.txt)'
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

