# 初期設定
コンソールケーブルで接続する。
ボーレートは`9600`、ストップビットは`8-N-1`に設定する。

## ■ ホスト名の設定
```
(config)# hostname <hostname>
```

## ■ パスワードの設定
### コンソールのパスワード
```
(config)# line console 0
(config-line)# password <password>
(config-line)# login
(config-line)# exit
```
### 特権モードのパスワード
```
(config)# enable secret <password>
```
### パスワード表示の暗号化
デフォルトでは、`show running-config`を実行するとパスワードが平文で表示されてしまうため、暗号化して表示する。
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
