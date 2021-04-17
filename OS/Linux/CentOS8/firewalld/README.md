# firewalld
## ■ 設定ファイルの編集
```
# vi /etc/firewalld/firewalld.conf
```
```
### [Option] nftablesからiptablesに変更(DirectRuleのACCEPTに関する挙動が異なる)
### DirectRuleを使用する場合はiptablesに変更するのがいいと思います。
-  FirewallBackend=nftables
+  FirewallBackend=iptables

### 非推奨設定なので無効化
-  AllowZoneDrifting=yes
+  AllowZoneDrifting=no
```
## ■ Zone
|zone|説明|
|:---:|:---|
|block||
|dmz||
|drop||
|external||
|home||
|internal||
|public||
|trusted||
|work||

## Zoneの確認
### デフォルトのZone確認
デフォルトで設定されているzoneを確認します。
```
# firewall-cmd --get-default-zone
```
```
<Zone>
```
### インターフェイス毎のZone確認
各NICがどのzone(デフォルトはpublic)に登録されているかを確認します。
```
# firewall-cmd --get-active-zones
```
```
<Zone>
  interfaces: <NIC>
```
## Zoneの設定
### デフォルトのZone設定
デフォルトのzoneを設定します。
```
# firewall-cmd --set-default-zone <Zone>
```
### インターフェイス毎のZone設定
```
# nmcli connection modify <Connection> connection.zone <Zone>
# nmcli connection up <Connection>
# nmcli connection show <Connection>
```
## ■ Rule
firewalldでは各Zoneに対してルールを設定します。  
通常のルールではサービス、ポート単位でのみのルールを管理します。  
送信元の制限などを設定できないため**個人的には**非推奨です。
## ■ RichRule
### Syntax - RichRule
```
### 追加
firewall-cmd [--permanent] [--zone=zone] --add-rich-rule    = <Rule>
### 削除
firewall-cmd [--permanent] [--zone=zone] --remove-rich-rule = <Rule>
```
### e.g.
```
# firewall-cmd --add-rich-rule="rule family=ipv4 source address=192.168.100.0/24 port protocol="tcp" port="80" accept"
```
## ■ DirectRule
読み込み優先度は`DirectRule > RichRule`であることを忘れないこと。  
DirectRuleとRichRuleの混在環境でDirectRule側からDROP設定を入れていたりするとRichRuleまでいけません。  
またDirectRuleはRichRuleと異なりゾーンに対してルールが設定されるわけではありません。  
書き方は冗長ですがルールはすべてDirectRuleで管理したい気持ちがあります。
### Syntax - DirectRule
```
### 追加
firewall-cmd [--permanent] --direct --add-rule    {ipv4|ipv6|eb} <テーブル> <チェイン> <優先順位> <引数>
### 削除
firewall-cmd [--permanent] --direct --remove-rule {ipv4|ipv6|eb} <テーブル> <チェイン> <優先順位> <引数>
```
### e.g.
```
# firewall-cmd --direct --add-chain ipv4 filter INPUT 1 -s 192.168.100.0/24 -p tcp -m state --state NEW --dport 22 -j ACCEPT
```
## ■ Ruleの反映
```
# firewall-cmd --reload
```
## ■ Logging
```
### 確認
# firewall-cmd --get-log-deneid

### 設定
# firewall-cmd --set-log-denied=all

### 確認
# firewall-cmd --get-log-deneid
```
messages等にfirewalldのログが行かないように出力先を変更します。
```
# vi /etc/rsyslog.conf
```
```
### messagesなどの出力設定の前に宣言すること
### こちらはすこし古いかもなので下を参照
+  :msg, contains, "FINAL_REJECT:"         -/var/log/firewall/firewalld.log
+  & stop

### 今はこっちのほうがいいかも
+  if $msg contains 'FINAL_REJECT' then /var/log/firewall.log
+  & stop
```
ログローテーションされるように設定します。
```
### 以下の設定は例です 要件に合わせて設定してください
# vi /etc/logrotate.d/firewall
```
```
/var/log/firewall/*.log
{
    ifempty
    missingok
    compress
    daily
    rotate 7
    postrotate
        /bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true
    endscript
}
```
最後に`telnet`コマンド等を使いファイアウォールにREJECTさせてログが出力されることを確認しましょう。
