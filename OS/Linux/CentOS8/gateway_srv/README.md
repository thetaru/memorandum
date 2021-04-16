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
まずインターフェースのゾーンを確認します。(未設定ならPublicだと思います。)
```
# firewall-cmd --get-active-zone
```
```
public
  interfaces: ens192 ens224
```
インターフェースのゾーンをens192は`external`、ens224は`internal`に設定します。
```
# nmcli connection modify ens192 connection.zone external
# nmcli connection modify ens224 connection.zone internal
```
変更できていることを確認します。
```
# firewall-cmd --get-active-zone
```
```
external
  interfaces: ens192
internal
  interfaces: ens224
```
次に、external側のゾーンにIPマスカレードの設定をします。
```
# firewall-cmd --zone=external --add-masquerade --permanent
```
変更できていることを確認します。
```
# firewall-cmd --zone=external --query-masquerade
```
```
yes
```
設定を反映させます。
```
# firewall-cmd --reload
```
IPフォワードの設定はIPマスカレード有効化により自動で有効になります。
