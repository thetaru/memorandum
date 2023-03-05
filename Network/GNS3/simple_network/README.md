# 簡単なネットワークの構築

## ■ ESW1の設定
```
> enable
# configure terminal
(config)# hostname ESW1
(config-vlan)# name sample
(config-vlan)# exit
(config)# interface range FastEthernet 1/0 - 2
(config-if-range)# switchport mode access
(config-if-range)# switchport access vlan 100
(config-if-range)# speed 100
(config-if-range)# duplex full
(config-if-range)# no shutdown
```
