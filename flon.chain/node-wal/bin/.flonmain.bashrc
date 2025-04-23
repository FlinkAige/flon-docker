source ~/bin/flonchain_main.env

alias newm="fucli wallet create -f ~/.main_password.txt -n \$mwalname"

function um() {
    if [ ! -f ~/.main_password.txt ]; then
        echo "❌ ~/.main_password.txt not found"
        return 1
    fi
    if [ -z "\$mwalname" ]; then
        echo "❌ Environment variable 'mwalname' is not set"
        return 1
    fi
    fucli wallet unlock -n "\$mwalname" --password "\$(cat ~/.main_password.txt)"
}

alias macct="fucli -u \$murl get account"
alias mcli="fucli -u \$murl"
alias mtbl="fucli -u \$murl get table"
alias mtran="fucli -u \$murl transfer"
alias mpush="fucli -u \$murl push action"
alias mpki="fucli wallet import -n \${mwalname} --private-key "

alias mreg="bash ~/bin/mreg.sh"
alias mset="bash ~/bin/mset.sh"
alias mnew="bash ~/bin/mnew.sh"
