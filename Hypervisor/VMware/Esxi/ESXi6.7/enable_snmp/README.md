# SNMP有効化
## SNMPサービスの有効化
```
$ esxcli system snmp set --enable true
```
## コミュニティ名の指定
```
$ esxcli system snmp set --communities <Community Name>
```
## SNMPマネージャの指定
```
$ esxcli system snmp set --targets <SNMP Manager IPADDR>/<Community Name>
```
## ファイアウォールの設定
SNMPへのアクセスを許可します。
```
$ esxcli network firewall ruleset set --ruleset-id=snmp --allowed-all true
$ esxcli network firewall ruleset set --ruleset-id=snmp --enabled true
```
## SNMPサービスの起動
```
$ etc/init.d/snmpd start
```
## 設定の確認
```
$ esxcli system snmp get
```
