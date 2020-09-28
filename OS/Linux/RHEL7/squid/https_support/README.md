# HTTPS対応Proxy
SELinuxが無効化されていることを前提に進めます。
## サーバー側の設定
```
# mkdir -p /etc/squid/ssl_cert
# chown squid:squid /etc/squid/ssl_cert
# chmod 700 /etc/squid/ssl_cert
# cd /etc/squid/ssl_cert
```
```
### 鍵と証明書を生成
# openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout server.key -out server.crt -days 3650
```
```
### 確認
# ll
```
```
-rw-r--r-- 1 root root 1911  9月 28 14:33 server.crt
-rw-r--r-- 1 root root 3272  9月 28 14:33 server.key
```
```
# /usr/lib64/squid/ssl_crtd -c -s /var/lib/ssl_db/ -M 4MB
```
```
# vi /etc/squid/squid.conf
```
```
# ローカルネットワーク(localnet)の定義
acl localnet src 192.168.0.0/24
acl localnet src 192.168.137.0/24

# SSL接続時に443ポートのCONNECTを許可
acl SSL_ports port 443
acl CONNECT method CONNECT

# SSL_portsで指定したポート以外を拒否
http_access deny CONNECT !SSL_ports

# 接続先として指定されているポートを許可
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http

# 接続先として指定されているポート以外を拒否
http_access deny !Safe_ports

# キャッシュの設定( manager を定義してないので無効な値)
http_access allow localhost manager
http_access deny manager

# ローカルネットワークからのアクセスを許可
http_access allow localnet

# 自身からのアクセスを許可
http_access allow localhost

# ここまで一致しなかった場合は拒否
http_access deny all

# Squid が使用するポート
http_port 8080 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/etc/squid/ssl_cert/server.crt key=/etc/squid/ssl_cert/server.key

# core 出力場所の設定
coredump_dir /var/spool/squid

# キャッシュ更新間隔の設定
refresh_pattern ^ftp:             1440    20%     10080
refresh_pattern ^gopher:          1440    0%      1440
refresh_pattern -i (/cgi-bin/|\?) 0       0%      0
refresh_pattern .                 0       20%     4320

# エラーページにバージョンを表示させない
httpd_suppress_version_string on

# アクセス元のIPを表示しない
forwarded_for off

# ローカルのホスト名の隠蔽
visible_hostname unknown

# Proxy経由であることを隠す(Squidのバージョンが3の場合)
request_header_access X-Forwarded-For deny all
request_header_access Via deny all
request_header_access Cache-Control deny all
reply_header_access X-Forwarded-For deny all
reply_header_access Via deny all
reply_header_access Cache-Control deny all

# SSLサーバのサービスに生み出すプロセスの最大数。
sslcrtd_children 5

# localhost以外からのリクエストはSSL interception 
ssl_bump server-first all

# 
sslproxy_cert_error deny all
```
```
# systemctl restart squid
```
## クライアント側の設定
```
### 証明書のインストール
# cd /etc/pki/ca-trust/source/anchors/
# scp root@<proxy-server>:/etc/squid/ssl_cert/server.crt ./
# update-ca-trust extract
```
```
### 確認
# curl https://www.google.com
```
