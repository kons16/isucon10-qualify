#!/bin/bash
set -e

sudo systemctl restart isuumo.go.service
sudo systemctl restart nginx
sudo systemctl restart mysql
sleep 5

echo | sudo tee /var/log/nginx/access.log

./bench -target-url http://127.0.0.1:8080

chmod 777 /var/log/nginx/access.log
if [ -e alp_kekka.txt ]; then
 rm alp_kekka.txt
fi

sleep 3
cat /var/log/nginx/access.log | alp ltsv --sort avg -r >> alp_kekka.txt

mkdir -p /www/data/logs
echo "<html><body><pre style=\"font-family: 'Courier New', Consolas\">" > /www/data/logs/alp.html
cat /var/log/nginx/access.log | alp ltsv --sort avg -r >> /www/data/logs/alp.html
echo "http://localhost:8080/logs/alp.html" | notify_slack

echo "<html><body><pre style=\"font-family: 'Courier New', Consolas\">" > /www/data/logs/pt.html
pt-query-digest --group-by fingerprint --order-by Query_time:sum /var/log/mysql/slow.log >> /www/data/logs/pt.html
echo "http://localhost:8080/logs/pt.html" | notify_slack
