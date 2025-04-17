#!/bin/bash
set -eu

source ./env
logfile="/data/log.txt"
redis_connect="redis-cli -h $REDIS_HOST -p $REDIS_PORT -a $REDIS_PASS"

while IFS=',' read -r ALERT_NAME HEAD_KEY TABLE_NAME CONTAINER_NAME; do
  echo "[INFO][$(date)] Checking $ALERT_NAME ($TABLE_NAME)" >> "$logfile"

  new_head=$(docker run --rm -e PGPASSWORD=$PG_PASS postgres:14 \
    psql -t -A -h $PG_HOST -p $PG_PORT -U $PG_USER -d $PG_DB -c "select head from $TABLE_NAME;")

  old_head=$($redis_connect GET "$HEAD_KEY" || echo 0)
  alert_status=$($redis_connect GET "$ALERT_NAME" || echo "")

  $redis_connect SET "$HEAD_KEY" "$new_head" > /dev/null

  if [ "$new_head" = "$old_head" ]; then
    if [ -z "$alert_status" ]; then
      $redis_connect SET "$ALERT_NAME" 1 && $redis_connect EXPIRE "$ALERT_NAME" 3600
    elif [ "$alert_status" = "1" ]; then
      text='{"parse_mode": "markdown","chat_id": '"$CHAT_ID"',"text": "*'"$ALERT_NAME"' 扫链 head 无变化，可能异常，请检查*"}'
      curl -s -X POST -H 'Content-Type: application/json' -d "$text" "$TG_BOT"
      $redis_connect SET "$ALERT_NAME" 2 && $redis_connect EXPIRE "$ALERT_NAME" 3600
      echo "[WARN][$(date)] $ALERT_NAME 无变化，已告警并重启 $CONTAINER_NAME" >> "$logfile"
      sleep 3
      docker restart "$CONTAINER_NAME"
    fi
  else
    if [ "$alert_status" = "2" ]; then
      text='{"parse_mode": "markdown","chat_id": '"$CHAT_ID"',"text": "*'"$ALERT_NAME"' 扫链已恢复正常 ✅*"}'
      curl -s -X POST -H 'Content-Type: application/json' -d "$text" "$TG_BOT"
    fi
    $redis_connect DEL "$ALERT_NAME"
    echo "[INFO][$(date)] $ALERT_NAME head 正常更新，状态清除" >> "$logfile"
  fi
done < monitors.conf