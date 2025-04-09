# Description: This script initializes the FLON blockchain by creating system accounts,
# activating protocol features, deploying contracts, and creating the FLON token.
#!/bin/bash

shopt -s expand_aliases
source ~/.bashrc

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

PUB_KEY="FU6JCHZ1boJBxjAwmUykCLFe9ipsR44GNTL2w4zgudwjVtHvbgTT"
CREATOR="flon"
CONTRACTS_DIR=$(realpath "$SCRIPT_DIR/../contracts")

# -------------------------
# 🧱 Create System Accounts
# -------------------------
ACCOUNTS=(
  flon.bpay
  flon.msig
  flon.names
  flon.fees
  flon.stake
  flon.token
  flon.reward
  flon.vote
  flon.evm
  flon.wrap
  flon.system
  evm.miner
)

echo "🚀 Creating system accounts..."
for acc in "${ACCOUNTS[@]}"; do
  echo "👉 Creating account: $acc"
  tcli create account $CREATOR $acc $PUB_KEY
done
echo "✅ System accounts created"
sleep 3
# -------------------------
# ⚙️ Activate Protocol Features (15 total)
# -------------------------
FEATURES=(
  # (same list)
)

echo "🚀 Activating protocol features..."
for digest in "${FEATURES[@]}"; do
  echo "👉 Activating feature: $digest"
  curl -s -X POST $NODE_URL/v1/producer/schedule_protocol_feature_activations \
    -d "{\"protocol_features_to_activate\": [\"$digest\"]}"
done
echo "✅ All protocol features activated"

echo "🚀 Deploying contracts..."
declare -A contracts=(
  ["flon"]="$CONTRACTS_DIR/flon.boot/"
  ["flon.token"]="$CONTRACTS_DIR/flon.token/"
  ["flon.msig"]="$CONTRACTS_DIR/flon.msig/"
  ["flon.system"]="$CONTRACTS_DIR/flon.system/"
  ["flon.wrap"]="$CONTRACTS_DIR/flon.wrap/"
)

deploy_contract() {
  local contract_name=$1
  local contract_path=$2

  echo "🚀 Deploying contract: $contract_name"
  tcli set contract $contract_name $contract_path
  echo "✅ Contract $contract_name deployed"
  sleep 1
  tcli set account permission $contract_name active --add-code
  echo "✅ Permissions set for contract $contract_name"
}

for contract in "${!contracts[@]}"; do
  deploy_contract "$contract" "${contracts[$contract]}"
done

echo "🚀 Creating FLON token..."
tcli push action flon.token create '["flon", "1000000000.00000000 FLON"]' -p flon.token
sleep 1
echo "🚀 Issuing FLON token..."
tcli push action flon.token issue '["flon", "900000000.00000000 FLON", "memo"]' -p flon

sleep 1

echo "🚀 Initializing system..."
tcli push action flon init '[0, "8,FLON"]' -p flon@active

echo "✅ FLON chain initialization complete ✅"
