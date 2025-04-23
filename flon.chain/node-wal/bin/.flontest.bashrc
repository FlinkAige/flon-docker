source ~/bin/flonchain_test.env

alias newt="fucli wallet create -f ~/.password.txt -n \$walname"

function ut() {
    if [ ! -f ~/.password.txt ]; then
        echo "❌ ~/.password.txt not found"
        return 1
    fi
    if [ -z "\$walname" ]; then
        echo "❌ Environment variable 'walname' is not set"
        return 1
    fi
    fucli wallet unlock -n "\$walname" --password "\$(cat ~/.password.txt)"
}

function generate_key_pair() {
  local result
  result=\$(tcli create key --to-console)

  echo "🔑 Key pair created:"
  echo "\$result"

  privKey=\$(echo "\$result" | grep "Private key:" | awk '{print \$3}')
  pubKey=\$(echo "\$result" | grep "Public key:" | awk '{print \$3}')

  pki \${privKey}

  echo "✅ Private Key: \$privKey"
  echo "✅ Public  Key: \$pubKey"

  export privKey
  echo "\$pubKey"
}

alias tacct="fucli -u \$turl get account"
alias tcli="fucli -u \$turl"
alias ttbl="fucli -u \$turl get table"
alias ttran="fucli -u \$turl transfer"
alias tpush="fucli -u \$turl push action"
alias pki="fucli wallet import -n \${walname} --private-key "

alias treg="bash ~/bin/treg.sh"
alias tset="bash ~/bin/tset.sh"
alias tnew="bash ~/bin/tnew.sh"
