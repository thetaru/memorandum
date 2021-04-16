# ゲートウェイサーバの構築
## ■ 前提条件
|項目|IP|Zone|説明|
|:---|:---|:---|:---|
|ens192|192.168.0.130|external|External Adapter|
|ens224|192.168.137.254|internal|Internal Adapter|

## ■ 構成概要
```
Internal                       External
|                              |
|        +------------+        |
| ens224 |            | ens192 |
+--------+   gw-srv   +--------+ GW: 192.168.0.1
|        |            |        |
|        +------------+        |
|                              |
```
## ■ 構築
## IPマスカレードの設定
firewalldでIPマスカレードの設定をします。  
インターフェースのゾーンをens192は`external`、ens224は`internal`に設定します。  
※ 未設定であればデフォルトのPublicだと思います。
```
# nmcli connection modify ens192 connection.zone external
# nmcli connection modify ens224 connection.zone internal
```
external側のゾーンにIPマスカレードの設定をします。
```
# firewall-cmd --permanent --zone=external --add-masquerade
```
設定を反映させます。
```
# firewall-cmd --reload
```
※ IPフォワードの設定はIPマスカレード有効化により自動で有効になります。(net.ipv4.ip_forward=1となっているはずです。)
## Gatewayとしての設定
internal側のゾーンにIPマスカレードの設定をします。
```
# firewall-cmd --permanent --zone=internal --add-masquerade
```
```
# firewall-cmd --reload
```
InternalインターフェースからExternalインターフェースへ転送する設定を入れます。
```
# firewall-cmd --permanent --direct --add-rule ipv4 nat POSTROUTING 0 -o eth192 -j MASQUERADE
# firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i eth224 -o eth192 -j ACCEPT
# firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -i eth192 -o eth224 -m state --state RELATED,ESTABLISHED -j ACCEPT
```
