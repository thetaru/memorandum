# Bonding + VLAN
## bond
### 追加
```
nmcli connection add type bond ifname bond0 con-name bond0 mode balance-rr
```

### 設定
```
nmcli connection modify bond0 ipv4.method disabled ipv6.method ignore
```

## slave
### 追加
```
nmcli connection add type bond-slave ifname eno1 con-name bond0-slave-eno3 master bond0
nmcli connection add type bond-slave ifname eno2 con-name bond0-slave-eno4 master bond0
nmcli connection add type bond-slave ifname eno3 con-name bond0-slave-eno5 master bond0
nmcli connection add type bond-slave ifname eno4 con-name bond0-slave-eno6 master bond0
```

### 設定
```
nmcli connection modify bond0-slave-eno1 connection.autoconnect yes
nmcli connection modify bond0-slave-eno2 connection.autoconnect yes
nmcli connection modify bond0-slave-eno3 connection.autoconnect yes
nmcli connection modify bond0-slave-eno4 connection.autoconnect yes
nmcli connection modify bond0 connection.autoconnect yes
nmcli connection modify bond0 connection.autoconnect-slaves 1
```

## vlan
### 追加
```
nmcli connection add type vlan ifname bond0.10 con-name bond0.10 dev bond0 vlan.parent bond0 id 10
nmcli connection add type vlan ifname bond0.20 con-name bond0.20 dev bond0 vlan.parent bond0 id 20
```

### 設定
```
nmcli connection modify bond0.10 connection.autoconnect yes ipv4.method manual ipv4.address "192.168.137.1/24" ipv4.gateway "192.168.137.254"
nmcli connection modify bond0.20 connection.autoconnect yes ipv4.method manual ipv4.address "192.168.137.2/24"
nmcli connection modify bond0.10 802-3-ethernet.auto-negotiate yes
nmcli connection modify bond0.20 802-3-ethernet.auto-negotiate yes
```
## interfaceの再起動
```
nmcli coonection down bond0
nmcli connection up bond0
nmcli coonection up bond0.10
nmcli coonection up bond0.20
nmcli connection show
```
