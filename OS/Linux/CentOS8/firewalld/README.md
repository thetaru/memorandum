# firewalld
https://densan-hoshigumi.com/server/linux/firewall  
https://qiita.com/Tocyuki/items/6d90a1ec4dd8e991a1ce
## ■ DirectRule
## ■ RichRule
## ■ Zone
## ■ Port
## ■ Service
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
/var/log/firewall/*.log {
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
