# squid
見本
## ■ /etc/squid/squid.conf
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
acl Safe_ports port 80    # http
acl Safe_ports port 21    # ftp
acl Safe_ports port 443   # https
acl Safe_ports port 70    # gopher
acl Safe_ports port 210   # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280   # http-mgmt
acl Safe_ports port 488   # gss-http
acl Safe_ports port 591   # filemaker
acl Safe_ports port 777   # multiling http

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
http_port 8080

# core 出力場所の設定
coredump_dir /var/spool/squid

# キャッシュ更新間隔の設定
refresh_pattern ^ftp:     1440    20%     10080
refresh_pattern ^gopher:  1440    0%1440
refresh_pattern -i (/cgi-bin/|\?) 0     0%0
refresh_pattern .   0 20%     4320

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
```
## [option]チューニング
### キャッシュ機能
```
# キャッシュのメモリサイズ
cache_mem 8 MB

# メモリの格納するオブジェクトの最大サイズ
maximum_object_size_in_memory 8 KB

# キャッシュする最大オブジェクトサイズ
maximum_object_size 20480 KB

# FQDNの最大キャッシュ数
fqdncache_size 1024

# キャッシュの保存先(100がディスクキャッシュ容量、16が一次ディレクトリ数、256が二次ディレクトリ数)
cache_dir ufs /var/spool/squid 100 16 256
```
