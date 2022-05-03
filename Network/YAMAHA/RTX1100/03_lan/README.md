# LAN設定
## ■ IPアドレスの設定
### VLANなし
```
### static
# ip lan1 address <address/mask>

### dhcp
# ip lan1 address dhcp
```
### VLANあり
```
### ポートVLAN
# ip vlan<vlan_num> address <address/mask>

### タグVLAN
# ip lan1/<num> address <address/mask>
```
