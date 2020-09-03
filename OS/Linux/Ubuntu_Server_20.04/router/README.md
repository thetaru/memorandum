# Router化
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
