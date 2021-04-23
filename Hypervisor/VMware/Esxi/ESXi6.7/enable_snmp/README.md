# SNMP有効化
## SNMPサービスの有効化
```
$ esxcli system snmp set --enable true
```
## SNMPサービスの設定
`-e`: 有効/無効  
`-c`: コミュニティ名  
`-t`: Trap送信先(<IPARRR>@<Port>/<CommunityName>)
```
$ esxcli system snmp set -e=true -c=<CommunityName> -t=<IPARRR>@<Port>/<CommunityName>
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
