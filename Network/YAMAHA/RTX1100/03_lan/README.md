# LAN設定
## ■ IPアドレスの設定
### VLANなし
```
# ip lan1 address <address/mask>
```
### VLANあり
```
### ポートVLAN
# ip vlan<vlan_num> address <address/mask>

### タグVLAN
# ip lan1/<num> address <address/mask>
```

## ■ ゲートウェイの設定
```
### static
# ip route default gateway <address>
```
