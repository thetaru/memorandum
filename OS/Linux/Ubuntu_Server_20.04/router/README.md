# Router化
# 前提条件
```
NIC1: enp2s0 ← ローカルネットワークへの口
NIC2: wlp3s0 ← インターネットへの口
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
```
$ sudo iptables -t nat -A POSTROUTING -o wlp3s0 -j MASQUERADE
$ sudo iptables -A FORWARD -i wlp3s0 -o enp2s0 -m state --state RELATED,ESTABLISHED -j ACCEPT
$ sudo iptables -A FORWARD -i enp2s0 -o wlp3s0 -j ACCEPT
```
## iptablesの設定の永続化
```
$ sudo apt-get install iptables-persistent
```
```
### 設定の永続化
$ sudo netfilter-persistent save
```
```
run-parts: executing /usr/share/netfilter-persistent/plugins.d/15-ip4tables save
run-parts: executing /usr/share/netfilter-persistent/plugins.d/25-ip6tables save
```
```
### 再起動後に設定がされているか確認
$ iptables -nL
```
