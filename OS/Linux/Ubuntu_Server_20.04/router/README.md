# Router化
# 前提条件
```
ここにdevとipと役割を書くよてい
ens02s: 
```

## IPフォワードの有効化
```
$ sudo sed -i'.bak' 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
```
```
### 反映
$ sudo sysctl -p

### 確認
$ sudo sysctl -a | grep net.ipv4.ip_forward
```
## IPマスカレード設定
## iptablesの設定の永続化
```
$ sudo apt-get install iptables-persistent
```
```
$ sudo netfilter-persistent save
```
```
run-parts: executing /usr/share/netfilter-persistent/plugins.d/15-ip4tables save
run-parts: executing /usr/share/netfilter-persistent/plugins.d/25-ip6tables save
```
