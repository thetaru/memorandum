# IPv6無効化
## 方法1: カーネルパラメータの変更
### :warning:注意事項:warning:
```NetworkManager```サービスを使用しているシステムでカーネルパラメータを変更することは***非推奨***です。
### カーネルパラメータの確認
IPv6が有効になっていることを確認します。
```
# sysctl -a | grep -e all.disable_ipv6 -e default.disable_ipv6
```
```
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
```
### カーネルパラメータの変更
```
# vi /etc/sysctl.conf
```
Ipv6を無効化するパラメータを追記します。
```
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
```
```/etc/sysctl.conf```に```net.ipv6.conf.all.disable_ipv6 や net.ipv6.conf.default.disable_ipv6```のパラメータが**ない**なら以下のコマンドでもいいです。
```
# echo "net.ipv6.conf.all.disable_ipv6 = 0" >> /etc/sysctl.conf
# echo "net.ipv6.conf.default.disable_ipv6 = 0" >> /etc/sysctl.conf
```
