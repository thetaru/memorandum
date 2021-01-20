# squid
## ■ /etc/squid/squid.conf
```
# ローカルネットワーク(localnet)の定義
# 多くなる場合はファイルを作ってそれを読み込ませる
acl localnet src 192.168.0.0/24
acl localnet src 192.168.137.0/24

# SSL接続時に443ポートのCONNECTを許可
acl SSL_ports port 443
acl SSL method CONNECT
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
http_port 8080

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
```
## ■ 個別設定
### 特定のページをキャッシュから除外
ある特定のページをキャッシュから除外する場合
```
# github.comをキャッシュしない例
acl QUERY urlpath_regex cgi-bin \? github.com
no_cache deny QUERY
```
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

# キャッシュの保存先(100MBの容量を16分割しそれぞれに256のフォルダが切られその中にキャッシングされる)
cache_dir ufs /var/spool/squid 100 16 256
```
### ファイルディスクリプタ数の設定
```
# I/Oが多いなら気持ち多めに設定する
max_filedesc 8192
```
### 短い間隔でアクセスすると、キャッシュが残りIPが切り替わらない
同じドメインに対して短い間隔で連続アクセスされた時に接続を使い回す仕様らしい。(i.e. IP分散が出来なくなってしまう)  
この現象を回避するために以下の設定が必要となります。
```
client_persistent_connections off
server_persistent_connections off
```
### 名前解決する際の挙動変更
```
# on  -> hostname or fqdn
# off -> fqdn Only
dns_defnames on
```
### 古いOS・ブラウザを制限
必要に応じてブラウザのバージョントークやOSのプラットフォームトークンを調べ`DenyBrowser`, `DenyOS`に登録する。
```
# define denied OS
acl DenyOS browser -i windows.95
acl DenyOS browser -i windows.98

# define denied Browser
acl DenyBrowser -i MSIE.4
acl DenyBrowser -i MSIE.5

# Deney OS/Browser
http_access deny DenyOS
http_access deny DenyBrowser

# Show Error message on Browser(※/etc/share/squid/errors/English に ERR_SECURITY_DENY ファイルを置く)
deny_info ERR_SECURITY_DENY DenyOS
deny_info ERR_SECURITY_DENY DenyBrowser
```
