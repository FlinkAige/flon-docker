#!/bin/bash

# -------------------------
# 🧩 基本配置
# -------------------------
#使用alias

#!/bin/bash

shopt -s expand_aliases
source ~/.bashrc


SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

PUB_KEY="FU6JCHZ1boJBxjAwmUykCLFe9ipsR44GNTL2w4zgudwjVtHvbgTT"
CREATOR="flon"
CONTRACTS_DIR=$(realpath "$SCRIPT_DIR/../contracts")

# -------------------------
# 🧱 创建系统账户
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
  evm.miner
)

echo "🚀 正在创建系统账户..."
for acc in "${ACCOUNTS[@]}"; do
  echo "👉 创建账户：$acc"
  tcli create account $CREATOR $acc $PUB_KEY
done
echo "✅ 系统账户创建完毕"

# -------------------------
# ⚙️ 激活协议特性（15 个）
# -------------------------
FEATURES=(
  "0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"  # preactivate feature
  "299dcb813b5e871e3ca3c9caf2b4eb5de5a7ba7825c3c520b2c4c4c1297c4226"  # get_sender
  "825ee902839a0b528ae313da70c851ff3d2aa602f8fe81c1f3667e8b5d2cdcd5"  # forward_set_code
  "5443fcf88330c586bc39f04d47c88c5a9ed1f7fc315e252b3bdb5b1106c1eeb6"  # only_billed_first_authorizer
  "f0af2b5fc74e2ae9c8fd0a42eb5d2a5993a3a4148fcb80a93bfc2be2b8e4eaa0"  # replace_deferred
  "bcd2a26394b29882b2f9116d08c07d0d9a53e994d293b2b2b60f843f38cb6d0d"  # no_duplicate_deferred_id
  "bf8e2c6a83f95fcf0da812184f4067f72b4c3a9383b4eb1065c4f83f17b1b4d3"  # fix_linkauth
  "68dcaa34c7df3c34c7dd287950d3ad94eaa116b0b9f5df0c60f1fcf3abf6c4fd"  # disallow_empty_producer_schedule
  "e0fb64b108c0489c6c0d210b86f250036c008ae08e4a9a039fdf20e8c1aaf645"  # restrict_action_to_self
  "bcd2a26394b29882b2f9116d08c07d0d9a53e994d293b2b2b60f843f38cb6d0d"  # more restrictive deferred
  "5c882a960bd29e0f37bb3d4cb3d3dd0c978ae04942a6c3f6747b6c88c5fb67cd"  # get_code_hash
  "1a99e59b2d3d3f80043f2d113f8cdd1452c9ebcda74b064fdc1ee3cfa34f1ab0"  # action return value
  "4e7bfba079cdb9a03e53f25b3ddf3f213a2eeec27be0f8be57a1a177d3c67759"  # kv_table
  "299dcb813b5e871e3ca3c9caf2b4eb5de5a7ba7825c3c520b2c4c4c1297c4226"  # get_sender (again, needed for some chains)
  "2c08e6cb305bd2b7d7fbe5a6877fcafe9fcecb9a0b50c7e831ae08f38b62e6a5"  # crypto primitives
)

echo "🚀 激活协议特性..."
for digest in "${FEATURES[@]}"; do
  echo "👉 激活特性：$digest"
  curl -s -X POST $NODE_URL/v1/producer/schedule_protocol_feature_activations \
    -d "{\"protocol_features_to_activate\": [\"$digest\"]}"
done
echo "✅ 所有协议特性已激活"

# -------------------------
# 📦 部署系统合约
# -------------------------
echo "🚀 部署合约..."
# 定义一个包含所有合约名称和路径的数组
declare -A contracts=(
  ["flon"]="$CONTRACTS_DIR/flon.boot/"
  ["flon.token"]="$CONTRACTS_DIR/flon.token/"
  ["flon.msig"]="$CONTRACTS_DIR/flon.msig/"
  ["flon.system"]="$CONTRACTS_DIR/flon.system/"
  ["flon.wrap"]="$CONTRACTS_DIR/flon.wrap/"
)

# 部署合约的函数
deploy_contract() {
  local contract_name=$1
  local contract_path=$2

  echo "🚀 正在部署合约: $contract_name"
  tcli set contract $contract_name $contract_path
  echo "✅ 合约 $contract_name 部署完成"
  tcli set account permission $contract_name active --add-code
  echo "✅ 合约 $contract_name 权限设置完成"
}

# 循环部署所有合约
for contract in "${!contracts[@]}"; do
  deploy_contract "$contract" "${contracts[$contract]}"
done

# -------------------------
# 💰 创建和发行代币
# -------------------------
echo "🚀 创建 FLON 代币..."
tcli push action flon.token create '["flon", "1000000000.00000000 FLON"]' -p flon.token

echo "🚀 发行 FLON 代币..."
tcli push action flon.token issue '["flon", "900000000.00000000 FLON", "memo"]' -p flon

# -------------------------
# 🔄 初始化系统
# -------------------------
echo "🚀 初始化系统..."
tcli push action flon init '[0, "8,FLON"]' -p flon@active

echo "✅ FLON 链初始化完成 ✅"
