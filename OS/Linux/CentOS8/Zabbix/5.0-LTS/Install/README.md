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
```
# vi /etc/httpd/conf/httpd.conf
```
```
-  ServerAdmin root@localhost
+  ServerAdmin <hostname>@<domain>
```
## ■ phpの設定
## ■ MariaDBの設定
