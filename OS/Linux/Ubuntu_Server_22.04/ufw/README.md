# ufw
## ufwの有効化
デフォルトで無効化されているため有効化する。
```sh
ufw enable
```

## ルールの追加
### Inbound
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
