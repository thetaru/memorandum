# ロギング
## アクセスログをsyslogサーバへ転送する
### ■ (squidサーバ側の設定)squid
```
access_log syslog:local1.info combined
```

### ■ (squidサーバ側の設定)rsyslog
/var/log/messagesにアクセスログが書き込まれないように修正します。
```
-  *.info;mail.none;authpriv.none;cron.none                /var/log/messages
+  *.info;mail.none;authpriv.none;cron.none;local1.info    /var/log/messages
```

syslogサーバに転送します。(あくまで例です)
```
+  action(Target="SYSLOG-SERVER" Port="514" Protocol="tcp")
```
