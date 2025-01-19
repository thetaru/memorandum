# ufw
## ufwの有効化
デフォルトで無効化されているため有効化する。
```sh
ufw enable
```

## デフォルトの設定
各方向のデフォルトの設定は、`ufw status verbose`から確認できる。
### Incoming
デフォルトでは、インバウンド通信は拒否(deny)になっている。
```sh
ufw default [allow|deny] incoming
```
### Outgoing
デフォルトでは、アウトバウンド通信は許可(allow)になっている。
```sh
ufw default [allow|deny] outgoing
```

## ルールの確認
デフォルトでは全拒否(ルールがない)となっている。
```sh
ufw status numbered
```

## ルールの追加
### Incoming
#### 送信元サブネットと宛先ポート番号およびプロトコルを指定して許可
```sh
# 送信元192.168.0.0/24から22/tcpポートへのアクセスを許可
ufw allow from 192.168.0.0/24 to any port 22 proto tcp
```
#### インターフェースと宛先ポート番号およびプロトコルを指定して許可
```sh
# インターフェースens18から来た22/tcpポートへのアクセスを許可
ufw allow in on ens18 to any port 22 proto tcp
```

## ルールの削除
削除対象ルールのルール番号を知る必要がある。
```sh
# ルール番号を確認
ufw status numbered
```
ルール番号を指定しルールを削除する。
```sh
ufw delete [number]
```

## ルールの初期化
ルールとufwの無効化を行うことができる。
```sh
ufw reset
```

## ログレベルの設定
デフォルトの設定は、`ufw status verbose`から確認できる。
```sh
ufw logging [on|off|level]
```
ログレベルごとの説明については以下を参照すること。
|level|description|
|-----|-----------|
|low||
|medium||
|high||
|full||

## スクリプト化
ルールを挿入することもできるが管理が面倒なのでスクリプトにしてしまう。  
以下に例を示す。
```sh
# Initialize ufw configuration
ufw --force reset
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw logging medium

# Add ufw rules
ufw allow from 192.168.0.0/24 to any port 22 proto tcp

# Show ufw rules
ufw status
```
