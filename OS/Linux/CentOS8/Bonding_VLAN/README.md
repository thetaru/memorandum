# Bonding + VLAN
bondに1つ以上のタグVLANを付与して通信する。  
今回の設定では次のようにする。

|interface name|
|:---|
|eno1|
|eno2|
|eno3|
|eno4|

|connection|type|
|:---|:---|
|bond0|bond|
|bond0-slave-eth1|slave|
|bond0-slave-eth2|slave|
|bond0-slave-eth3|slave|
|bond0-slave-eth4|slave|
|bond0.10|VLAN(id=10)|
|bond0.20|VLAN(id=20)|

|mode|説明|スイッチ側の設定|
|:---|:---|:---|
|balance-rr|||
|active-backup|||
|balance-xor|||
|broadcast|||
|802.3ad|||
|balance-tlb|||
|balance-alb|||

## ■ bond
### 追加
```sh
nmcli connection add type bond ifname bond0 con-name bond0 mode balance-rr
```

### 設定
```sh
nmcli connection modify bond0 ipv4.method disabled ipv6.method ignore
```

## ■ slave
### 追加
```sh
nmcli connection add type bond-slave ifname eno1 con-name bond0-slave-eth1 master bond0
nmcli connection add type bond-slave ifname eno2 con-name bond0-slave-eth2 master bond0
nmcli connection add type bond-slave ifname eno3 con-name bond0-slave-eth3 master bond0
nmcli connection add type bond-slave ifname eno4 con-name bond0-slave-eth4 master bond0
```

### 設定
```sh
nmcli connection modify bond0-slave-eth1 connection.autoconnect yes
nmcli connection modify bond0-slave-eth2 connection.autoconnect yes
nmcli connection modify bond0-slave-eth3 connection.autoconnect yes
nmcli connection modify bond0-slave-eth4 connection.autoconnect yes
nmcli connection modify bond0 connection.autoconnect yes
nmcli connection modify bond0 connection.autoconnect-slaves 1
```

## ■ vlan
### 追加
```sh
nmcli connection add type vlan ifname bond0.10 con-name bond0.10 dev bond0 vlan.parent bond0 id 10
nmcli connection add type vlan ifname bond0.20 con-name bond0.20 dev bond0 vlan.parent bond0 id 20
```

### 設定
```sh
nmcli connection modify bond0.10 connection.autoconnect yes ipv4.method manual ipv4.address "192.168.137.1/24" ipv4.gateway "192.168.137.254"
nmcli connection modify bond0.20 connection.autoconnect yes ipv4.method manual ipv4.address "192.168.137.2/24"
nmcli connection modify bond0.10 802-3-ethernet.auto-negotiate yes
nmcli connection modify bond0.20 802-3-ethernet.auto-negotiate yes
```
## ■ interfaceの再起動
```sh
nmcli coonection down bond0
nmcli connection up bond0
nmcli coonection up bond0.10
nmcli coonection up bond0.20
nmcli connection show
```
## ■ 確認
NICを抜き差しして冗長されていることを確認する。
```sh
watch -n 5 /proc/net/bonding/bond0
```

## ■ Ref
- https://www.kernel.org/doc/Documentation/networking/bonding.txt
