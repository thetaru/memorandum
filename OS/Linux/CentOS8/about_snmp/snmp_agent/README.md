# SNMPエージェントの設定
## ■ インストール
## ■ バージョンの確認
```
# snmpd -v
```
## ■ サービスの起動
```
# systemctl enable --now snmpd.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|snmpd.service|161/udp||

## ■ 主設定ファイル /etc/snmp/snmpd.conf
### ● パラメータ
### com2sec
#### Syntax
```
com2sec sec.name source community
```
### group
### view
### access
### syslocation
### syscontact
### dontLogTCPWrappersConnect
### ● 設定例
```
com2sec MyUser   default  public
group   MyGroup  v1       MyUser
group   MyGroup  v2c      public
view    view_all included .1
access  MyGroup  "" any noauth exact view_all none none
```
## ■ 設定ファイル /etc/snmp/snmptrapd.conf
## ■ 設定ファイル /etc/sysconfig/snmpd
### ● 設定例
## ■ セキュリティ
### firewall
## ■ ログ
## ■ ログローテーション
## ■ 設定の反映
