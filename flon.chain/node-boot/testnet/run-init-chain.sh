# Description: This script initializes the FLON blockchain by creating system accounts,
# activating protocol features, deploying contracts, and creating the FLON token.
#!/bin/bash

shopt -s expand_aliases
source ~/.bashrc

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

PUB_KEY="FU6JCHZ1boJBxjAwmUykCLFe9ipsR44GNTL2w4zgudwjVtHvbgTT"
CREATOR="flon"
CONTRACTS_DIR=$(realpath "$SCRIPT_DIR/../contracts")
NODE_URL=$turl

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
PREACTIVATE_FEATURE="0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"  # preactivate feature

echo "👉 Activating feature: $PREACTIVATE_FEATURE"
curl -s -X POST $NODE_URL/v1/producer/schedule_protocol_feature_activations \
    -d "{\"protocol_features_to_activate\": [\"$PREACTIVATE_FEATURE\"]}"
sleep 3

# Deployment function
deploy_contract() {
  local contract_name=$1
  local contract_path=$2

  echo "🚀 Deploying contract: $contract_name"
  tcli set contract "$contract_name" "$contract_path"
  echo "✅ Contract $contract_name deployed"
}

deploy_contract flon "$CONTRACTS_DIR/flon.boot/"

sleep 3

FEATURES=(
  "c3a6138c5061cf291310887c0b5c71fcaffeab90d5deb50d3b9e687cead45071"  # ACTION_RETURN_VALUE
  "d528b9f6e9693f45ed277af93474fd473ce7d831dae2180cca35d907bd10cb40"  # CONFIGURABLE_WASM_LIMITS2
  "5443fcf88330c586bc0e5f3dee10e7f63c76c00249c87fe4fbf7f38c082006b4"  # BLOCKCHAIN_PARAMETERS
  "f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"  # GET_SENDER
  "2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"  # FURWARD_SETCODE
  "8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"  # ONLY_BILL_FIRST_AUTHORIZER
  "ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"  # RESTRICT_ACTION_TO_SELF
  "68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"  # DISALLOW_EMPTY_PRODUCER_SCHEDULE
  "e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"  # FIX_LINKAUTH_RESTRICTION
  "1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"  # ONLY_LINK_TO_EXISTING_PERMISSION
  "4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"  # RAM_RESTRICTIONS
  "4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"  # WEBAUTHN_KEY
  "299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"  # WTMSIG_BLOCK_SIGNATURES
  "bcd2a26394b36614fd4894241d3c451ab0f6fd110958c3423073621a70826e99"  # GET_CODE_HASH
  "35c2186cc36f7bb4aeaf4487b36e57039ccf45a9136aa856a5d569ecca55ef2b"  # GET_BLOCK_NUM
  "6bcb40a24e49c26d0a60513b6aeb8551d264e4717f306b81a37a5afb3b47cedc"  # CRYPTO_PRIMITIVES
  "63320dd4a58212e4d32d1f58926b73ca33a247326c2a5e9fd39268d2384e011a"  # BLS_PRIMITIVES2
  "72df75c0bf7fce15d7b95d8565eba38ff58231789273d39c68693c3557d64c54"  # SAVANNA
)

echo "🚀 Activating protocol features..."
for digest in "${FEATURES[@]}"; do
  echo "👉 Activating feature: $digest"
  tpush flon activate '["'$disgest'"]' -p flon@active
  sleep 3
done
echo "✅ All protocol features activated"

echo "🚀 Deploying contracts..."
# Define contract configurations
declare -A contracts=(
  ["flon.token"]="$CONTRACTS_DIR/flon.token/"
  ["flon.msig"]="$CONTRACTS_DIR/flon.msig/"
  ["flon.system"]="$CONTRACTS_DIR/flon.system/"
  ["flon.wrap"]="$CONTRACTS_DIR/flon.wrap/"
)

# Deploy contracts in order
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
