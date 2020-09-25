# squid
`/etc/squid/squid.conf`の設定値の概要を把握します。
## アクセス制御
ローカルネットワークを定義します。ここからのアクセスなら許しますってやつです。
```
# 192.168.137.0/24からのアクセスを許可する
acl localnet src 192.168.137.0/24
```
## 接続先ポート制御
接続先として指定されているポートを許可します。
```
acl Safe_ports port 80    # http
acl Safe_ports port 21    # ftp
acl Safe_ports port 443   # https
```
`acl Safe_ports port`で指定した以外のポートを拒否します。
```
http_access deny !Safe_ports
```
