#!/bin/bash
### 初期セットアップ用
set -e

apt-get update
apt-get install -y unzip

### alp
echo "starting alp install...."
wget https://github.com/tkuchiki/alp/releases/download/v1.0.3/alp_linux_amd64.zip
unzip alp_linux_amd64.zip
rm alp_linux_amd64.zip
mv alp /usr/local/bin/

### prometheus
echo "starting prometheus install...."
apt-get update
apt-get install -y prometheus prometheus-node-exporter
ufw allow 9090
systemctl start prometheus.service
systemctl start prometheus-node-exporter-apt.service
systemctl start prometheus-node-exporter-ipmitool-sensor.service
systemctl start prometheus-node-exporter-mellanox-hca-temp.service
systemctl start prometheus-node-exporter-smartmon.service
systemctl start prometheus-node-exporter.service

### Grafana
echo "starting Grafana install...."
apt-get install -y apt-transport-https
apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
apt-get update
apt-get install -y grafana
ufw allow 3000
systemctl start grafana-server
### CPU使用率 Query : rate(node_cpu_seconds_total{job="prometheus",mode="system"}[5m]) * 100
### メモリ使用率　Query : node_memory_MemTotal_bytes{instance="localhost:9100",job="prometheus"}

### pt-query-digest
echo "starting pt-query-digest install...."
apt-get update
apt-get install -y percona-toolkit

### リポジトリに nginx のシンボリックリンクを貼る
echo "nginx のシンボリックリンクを作成中"
cp -r /etc/nginx /home/isucon/nginx
rm -rf /etc/nginx/
ln -s /home/isucon/nginx /etc/nginx
