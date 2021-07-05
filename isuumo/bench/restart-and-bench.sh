#!/bin/bash
set -e

sudo systemctl restart isuumo.go.service
sudo systemctl restart nginx
sudo systemctl restart mysql
sleep 5

echo | sudo tee /var/log/nginx/access.log

./bench
cat /var/log/nginx/access.log | alp ltsv --sort avg -r
