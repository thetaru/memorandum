# Bonding + VLAN
## bond
### 追加
```
nmcli connection add type bond ifname bond0 con-name bond0 mode balance-rr
```

### 設定
```
nmcli connection modify ipv4.method disabled ipv6.method ignore
```

## slave
### 追加
```
nmcli connection add type bond-slave ifname eno3 con-name bond0-slave-eno3 master bond0
nmcli connection add type bond-slave ifname eno4 con-name bond0-slave-eno4 master bond0
nmcli connection add type bond-slave ifname eno5 con-name bond0-slave-eno5 master bond0
nmcli connection add type bond-slave ifname eno6 con-name bond0-slave-eno6 master bond0
```

### 設定
```
nmcli connection modify bond0-slave-eno3 connection.autoconnect yes
nmcli connection modify bond0-slave-eno4 connection.autoconnect yes
nmcli connection modify bond0-slave-eno5 connection.autoconnect yes
nmcli connection modify bond0-slave-eno6 connection.autoconnect yes
nmcli connection modify bond0 connection.autoconnect yes
nmcli connection modify bond0 connection.autoconnect-slaves 1
```

## vlan
### 追加
```
nmcli connection add type vlan ifname bond0.3001 con-name bond0.3001 dev bond0 vlan.parent bond0 id 3001
nmcli connection add type vlan ifname bond0.3240 con-name bond0.3240 dev bond0 vlan.parent bond0 id 3240
```

### 設定
```
nmcli connection modify bond0.3001 connection.autoconnect yes ipv4.method manual ipv4.address "172.19.1.1/24" ipv4.gateway "172.19.1.254"
nmcli connection modify bond0.3240 connection.autoconnect yes ipv4.method manual ipv4.address "172.19.240.11/24"
nmcli connection modify bond0.3001 802-3-ethernet.auto-negotiate yes
nmcli connection modify bond0.3240 802-3-ethernet.auto-negotiate yes
```
## interface再起動
```
nmcli coonection down bond0
nmcli coonection down bond0.3001
nmcli coonection down bond0.3240
nmcli coonection up bond0.3001
nmcli coonection up bond0.3240
nmcli connection up bond0
nmcli connection show
```