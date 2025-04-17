sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

sudo yum install postgresql redis

测试：
sh -x chain_scan_monitor.sh 

*/1 * * * * root /bin/bash /data/scripts/chain_scan_monitor.sh &>/dev/null
写入到 /etc/crontab