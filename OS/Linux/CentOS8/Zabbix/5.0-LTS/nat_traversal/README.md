# IPマスカレードをはさんだ監視
いつもの設定でやったらエラーがでたのでメモです。
## ■ エラー内容
```
failed to accept an incoming connection: connection from "監視対象のIPアドレス" rejected, allowed hosts: "ZabbixサーバのIPアドレス"
```
Firewallに引っかかってるのかと思ってルールの見直しをしてみたけどどうもちがうらしいので調べてみた。  
原因はおそらく、IP変換が行われているからだと思う。

## ■ 構成概要
|NW|Interface|ホスト名|IP|
|:---|:---|:---|:---|
|NW#1|eth0|zab-agent|192.168.137.1|
|NW#1|ens224|gw-srv1|192.168.137.254|
|NW#2|ens192|gw-srv1|192.168.0.100|
|NW#2|eth1|zab-serve|192.168.0.101|

GWをはさんでzabbixサーバと通信したい。  
また、gw-srv1ではフォワーディングが行われており、zabbixサーバは10051/tcpでリッスンしているとする。
```
                     NW#1 (192.168.137.0/24)       NW#2 (192.168.0.0/24)
                     |                             |
+-----------+        |        +-----------+        |        +-----------+
|           |  eth0  | ens224 |           | ens192 |  eth1  |           |
+ zab-agent +--------+--------+  gw-srv1  +--------+--------+ zab-serve |
|           |        |        |           |        |        |           |
+-----------+        |        +-----------+        |        +-----------+
                     |                             |
                     |                             |
```
## ■ 設定
zabbixクライアントの方で以下の設定に変更する。
```
# vi /etc/zabbix/zabbix-agent.conf
```
```
+  Server=192.168.0.101,192.168.137.254
+  ServerActive=192.168.0.101:10051
```
ServerにzabbixサーバのIPアドレスと経由するGWのIPを指定すればいい。
