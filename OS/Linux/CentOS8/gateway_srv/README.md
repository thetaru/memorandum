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
## ■ Firewall設定例
INPUTなどはよしなに追加などしてください...
### 全許可型
ポートによる制限なし
```xml
<?xml version="1.0" encoding="utf-8"?>
<direct>
  <!-- Policy -->
  <rule priority="2" table="filter" ipv="ipv4" chain="INPUT">-j DROP</rule>
  <rule priority="2" table="filter" ipv="ipv4" chain="OUTPUT">-j ACCEPT</rule>
  <rule priority="2" table="filter" ipv="ipv4" chain="FORWARD">-j ACCEPT</rule>
  <!-- Gateway -->
  <rule priority="1" ipv="ipv4" table="nat" chain="POSTROUTING">-o ens224 -j MASQUERADE</rule>
  <rule priority="1" ipv="ipv4" table="filter" chain="FORWARD">-i ens192 -o ens224 -m state --state RELATED,ESTABLISHED -j ACCEPT</rule>
  <rule priority="0" ipv="ipv4" table="filter" chain="FORWARD">-i ens224 -o ens192 -j ACCEPT</rule>
  <!-- Input rule -->
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-s 192.168.137.0/24 -p tcp -m state --state NEW --dport 22 -j ACCEPT</rule>
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-s 192.168.0.0/24 -p tcp -m state --state NEW --dport 22 -j ACCEPT</rule>
</direct>
```
### ポート制限型
pingとDNS、HTTP、HTTPSを許可しています。  
追加したい場合は、Forward ruleのところにいい感じに追加してどうぞ。  
フォワード元を制限したい場合は`-s`を、フォワード先を制限したい場合は`-d`をつけてください。  
```xml
<?xml version="1.0" encoding="utf-8"?>
<direct>
  <!-- Policy -->
  <rule priority="2" table="filter" ipv="ipv4" chain="INPUT">-j DROP</rule>
  <rule priority="2" table="filter" ipv="ipv4" chain="OUTPUT">-j ACCEPT</rule>
  <rule priority="2" table="filter" ipv="ipv4" chain="FORWARD">-j DROP</rule>
  <!-- Forward rule -->
  <rule priority="1" ipv="ipv4" table="nat" chain="POSTROUTING">-o ens224 -j MASQUERADE</rule>
  <rule priority="1" ipv="ipv4" table="filter" chain="FORWARD">-i ens192 -o ens224 -m state --state RELATED,ESTABLISHED -j ACCEPT</rule>
  <rule priority="1" ipv="ipv4" table="filter" chain="FORWARD">-p icmp -j ACCEPT</rule>
  <rule priority="1" ipv="ipv4" table="filter" chain="FORWARD">-p tcp -m state --state NEW --dport 53 -j ACCEPT</rule>
  <rule priority="1" ipv="ipv4" table="filter" chain="FORWARD">-p udp -m state --state NEW --dport 53 -j ACCEPT</rule>
  <rule priority="1" ipv="ipv4" table="filter" chain="FORWARD">-p tcp -m state --state NEW --dport 80 -j ACCEPT</rule>
  <rule priority="1" ipv="ipv4" table="filter" chain="FORWARD">-p udp -m state --state NEW --dport 123 -j ACCEPT</rule>
  <rule priority="1" ipv="ipv4" table="filter" chain="FORWARD">-p tcp -m state --state NEW --dport 443 -j ACCEPT</rule>
  <!-- Common rule -->
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-i lo -j ACCEPT</rule>
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-m state --state RELATED,ESTABLISHED -j ACCEPT</rule>
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-p icmp -j ACCEPT</rule>
  <!-- Input rule -->
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-s 192.168.137.0/24 -p tcp -m state --state NEW --dport 22 -j ACCEPT</rule>
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-s 192.168.137.0/24 -p tcp -m state --state NEW --dport 80 -j ACCEPT</rule>
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-s 192.168.138.0/24 -p tcp -m state --state NEW --dport 22 -j ACCEPT</rule>
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-s 192.168.138.0/24 -p tcp -m state --state NEW --dport 80 -j ACCEPT</rule>
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-s 192.168.0.0/24 -p tcp -m state --state NEW --dport 22 -j ACCEPT</rule>
  <rule priority="1" table="filter" ipv="ipv4" chain="INPUT">-s 192.168.0.0/24 -p tcp -m state --state NEW --dport 80 -j ACCEPT</rule>
</direct>
```
