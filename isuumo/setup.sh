# alp
wget https://github.com/tkuchiki/alp/releases/download/v1.0.3/alp_linux_amd64.zip
unzip alp_linux_amd64.zip
rm alp_linux_amd64.zip
mv alp /usr/local/bin/

# nginxをgit管理下に設定する
cp -r /etc/nginx /home/isucon/nginx
rm -rf /etc/nginx/
ln -s /home/isucon/nginx /etc/nginx

