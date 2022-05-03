# 初期設定
コンソールケーブルで接続する。
ボーレートは`9600`、ストップビットは`8-N-1`に設定する。

## ■ ホスト名の設定
```
(config)# hostname <hostname>
```

## ■ パスワードの設定
### コンソール接続時のパスワード
```
(config)# line console 0
(config-line)# password <password>
(config-line)# login
(config-line)# exit
```
### enableパスワード
```
(config)# enable secret <password>
```
### パスワード暗号化
```
(config)# service password-encryption
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
デフォルトで`interface Vlan1`の管理インターフェースが存在するので、そこにIPアドレスを設定することが多い。
```
(config)#interface vlan <vlan-id>
(config-if)#ip address <address> <mask>
(config-if)#no shutdown
```

## ■ デフォルトゲートウェイの設定
```
(config)# ip default-gateway <address>
```
