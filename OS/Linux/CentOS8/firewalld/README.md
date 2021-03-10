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
### kakunin
# firewall-cmd --get-log-deneid

### settei
# firewall-cmd --set-log-denied=all

### kakunin
# firewall-cmd --get-log-deneid
```
rogusyurutyokusakisettei
```
# vi /etc/rsyslog.conf
```
```
### fairu syuturyou no mae
+  :msg, contains, "FINAL_REJECT:"         -/var/log/firewall/firewalld.log
+  &stop
```
roguro-teto
```
# vi /etc/logrotate.d/firewall
```
```
/var/log/firewall/*.log {
}
```
