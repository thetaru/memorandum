# SNMPエージェントの設定
## ■ インストール
```
# yum install net-snmp
```
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
|snmpd.service|161/udp,199/tcp||
|snmptrapd.service|162/udp|

## ■ 主設定ファイル /etc/snmp/snmpd.conf
### ● com2sec
#### Syntax
```
com2sec sec.name source community
```
### ● group
#### Syntax
```
group groupName securityModel securityName
```
### ● view
#### Syntax
```
view name incl/excl subtree mask(optional)
```
### ● access
#### Syntax
```
access group context sec.model sec.level prefix read write notif
```
### ● syslocation
#### Syntax
```
sysContact STRING
```
### ● syscontact
#### Syntax
```
sysLocation STRING
```
### ● dontLogTCPWrappersConnect
#### Syntax
```
dontLogTCPWrappersConnects (yes|no)
```
### ● proc
#### Syntax
```
proc NAME [MAX [MIN]]
```
### ● disk
#### Syntax
```
disk PATH [ MINSPACE | MINPERCENT% ]
```
### ● load
#### Syntax
```
load MAX1 [MAX5 [MAX15]]
```
### ● exec
#### Syntax
```
exec [MIBOID] NAME PROG ARGS
```
### ● pass
#### Syntax
```
pass [-p priority] MIBOID PROG
```
### 設定例
```
com2sec MyUser   default  public
group   MyGroup  v1       MyUser
group   MyGroup  v2c      MyUser
view    view_all included .1
access  MyGroup  "" any noauth exact view_all none none
```
## ■ 設定ファイル /etc/snmp/snmptrapd.conf
## ■ 設定ファイル /etc/sysconfig/snmpd
SMUXを無効化する
### 設定例
```
OPTIONS="-Lsd -Lf /dev/null -p /var/run/snmpd -a -I -smux"
```
## ■ セキュリティ
### firewall
## ■ ロギング
## ■ 設定の反映
```
# systemctl restart snmpd.service
```
