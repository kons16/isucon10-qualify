#!/bin/bash
set -e

sudo systemctl restart isuumo.go.service
sudo systemctl restart nginx
sudo systemctl restart mysql
sleep 5

echo | sudo tee /var/log/nginx/access.log

./bench -target-url http://127.0.0.1:8080
chmod 777 /var/log/nginx/access.log
rm alp_kekka.txt
/var/log/nginx/access.log | alp ltsv --sort avg -r >> alp_kekka.txt

