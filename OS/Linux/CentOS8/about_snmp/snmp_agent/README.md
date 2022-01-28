# SNMPエージェントの設定
## ■ インストール
```
# yum install net-snmp net-snmp-utils
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
# ACCESS CONTROL
## VACM Configuration
### ● com2sec
#### Syntax
```
com2sec [-Cn CONTEXT] SECNAME SOURCE COMMUNITY
```
### ● group
#### Syntax
```
group GROUP {v1|v2c|usm|tsm|ksm} SECNAME
```
### ● view
#### Syntax
```
view VNAME TYPE OID [MASK]
```
### ● access
#### Syntax
```
access GROUP CONTEXT {any|v1|v2c|usm|tsm|ksm} LEVEL PREFX READ WRITE NOTIFY
```

# SYSTEM INFORMATION
## System Group
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

## Process Monitoring
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

# OTHER CONFIGURATION
### ● dontLogTCPWrappersConnect
#### Syntax
```
dontLogTCPWrappersConnects (yes|no)
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
SMUX(199/tcp)を無効化する
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
