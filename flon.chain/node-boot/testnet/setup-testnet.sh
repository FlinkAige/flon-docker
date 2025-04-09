source .env

tcli='fucli --wallet-url http://127.0.0.1:6666  --url http://127.0.0.1:8888'

# 创建账户
FILE="accounts.txt"
if [[ ! -f "$FILE" ]]; then
  echo "文件 $FILE 不存在！"
  exit 1
fi

# 逐行读取文件
while IFS=',' read -r account_name public_key; do
  account_name=$(echo "$account_name" | xargs)
  public_key=$(echo "$public_key" | xargs)

  echo "处理账户: $account_name, 公钥: $public_key"

  fucli --wallet-url http://127.0.0.1:6666 --url http://127.0.0.1:8888 create account flon "$account_name" "$public_key"

  if [[ $? -eq 0 ]]; then
    echo "账户 $account_name 创建成功！"
  else
    echo "账户 $account_name 创建失败！"
  fi

done < "$FILE"