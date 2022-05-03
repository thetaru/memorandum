# 初期設定
コンソールケーブルで接続する。
ボーレートは`9600`、ストップビットは`8-N-1`に設定する。

## ■ ホスト名の設定
```
(config)# hostname <hostname>
```

## ■ インターフェースの設定
```
# インターフェースの有効化
(config)# interface <interface>
(config-if)# no shutdown

# インターフェースの無効化
(config)# interface <interface>
(config-if)# shutdown
```

## ■ 管理用IPアドレスの設定
管理用IPアドレスをSVI(Switched Virtual Interface)に設定する。  
```
(config)#interface vlan <vlan-id>
(config-if)#ip address <address> <mask>
(config-if)#no shutdown
```
