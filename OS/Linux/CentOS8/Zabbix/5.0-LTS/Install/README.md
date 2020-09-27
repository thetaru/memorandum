# ZabbixのInstall
## ■ SELinuxの無効化
```
# vi /etc/selinuc/config
```
```
-  SELINUX=enforcing
+  SELINUX=disabled
```
## ■ apacheの設定
[ここ](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/apache)を参考にしてください。
## ■ PHPの設定
## ■ MariaDBの設定
## ■ Zabbixの設定
```
# vi /etc/zabbix/zabbix_server.conf
```
```
-  #ListenPort=10051
+  ListenPort=10051

-  LogFileSize=0
+  LogFileSize=20

-  CacheSize=8M
+  CacheSize=32M
```
