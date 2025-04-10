source ~/bin/flonchain.env

alias newt="fucli wallet create -f ~/.password.txt -n $walname"
alias newm="fucli wallet create -f ~/.main_password.txt -n $mwalname"
function ut() {
    if [ ! -f ~/.password.txt ]; then
        echo "❌ ~/.password.txt not found"
        return 1
    fi
    if [ -z "$walname" ]; then
        echo "❌ Environment variable 'walname' is not set"
        return 1
    fi
    fucli wallet unlock -n "$walname" --password "$(cat ~/.password.txt)"
}

function um() {
    if [ ! -f ~/.main_password.txt ]; then
        echo "❌ ~/.main_password.txt not found"
        return 1
    fi
    if [ -z "$mwalname" ]; then
        echo "❌ Environment variable 'mwalname' is not set"
        return 1
    fi
    fucli wallet unlock -n "$mwalname" --password "$(cat ~/.main_password.txt)"
}


alias tacct="fucli -u $turl get account"
alias macct="fucli -u $murl get account"
alias tcli="fucli -u $turl"
alias mcli="fucli -u $murl"
alias ttbl="fucli -u $turl get table"
alias mtbl="fucli -u $murl get table"
alias ttran="fucli -u $turl transfer"
alias mtran="fucli -u $murl transfer"
alias tpush="fucli -u $turl push action"
alias mpush="fucli -u $murl push action"
alias pki="fucli wallet import -n ${walname} --private-key "
alias mpki="fucli wallet import -n ${mwalname} --private-key "
alias treg="bash ~/bin/treg.sh"
alias mreg="bash ~/bin/mreg.sh"
alias tset="bash ~/bin/tset.sh"
alias mset="bash ~/bin/mset.sh"

alias tnew="bash ~/bin/tnew.sh"

