# firewalld
https://densan-hoshigumi.com/server/linux/firewall  
https://qiita.com/Tocyuki/items/6d90a1ec4dd8e991a1ce
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

## ■ DirectRule
読み込み優先度は`DirectRule > RichRule`であることを忘れないこと。  
DirectRuleとRichRuleの混在環境でDirectRule側からDROP設定を入れていたりするとRichRuleまでいけません。
## ■ RichRule
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
+  :msg, contains, "FINAL_REJECT:"         -/var/log/firewall/firewalld.log
+  &stop
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
最後に`telnet`コマンド等を使いファイアウォールにREJECTさせてログが出力されつことを確認しましょう。
