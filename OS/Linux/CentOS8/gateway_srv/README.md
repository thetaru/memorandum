# ゲートウェイサーバの構築
## ■ 構成概要
## ■ 構築
### IPフォワードの設定
```
# vi /etc/sysctl.conf
```
```
+  net.ipv4.ip_forward=1
```
カーネルパラメータを反映させます。
```
# sysctl -p
```
## ■ パラメータ詳細
- [ ] [TCP帯域幅(bandwidth)関連パラメータ]()
