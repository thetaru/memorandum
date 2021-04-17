# ZabbixのInstall
## ■ SELinuxの無効化
```
# vi /etc/selinuc/config
```
```
-  SELINUX=enforcing
+  SELINUX=disabled
```
## ■ firewalldの設定
```
### 無効化してしまう場合
# systemctl stop firewalld
# systemctl disable firewalld
```
## ■ apacheの設定
[ここ](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/apache)を参考にしてください。
## ■ Zabbixの設定
以下は最低限の設定です。環境に応じて設定値を変更してください。
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
## ■ PHPの設定
```
# vi /etc/php-fpm.d/zabbix.conf
```
```
-  ;php_value[date.timezone] = Euro/Riga
+  php_value[date.timezone] = Asia/Tokyo
```
## ■ MariaDBの設定
```
# yum install mariadb-server
```
最低限のセキュリティ設定をしてくれるコマンドを実行します。
```
# mysql_secure_installation
```
## ■ サービスの起動
```
# systemctl start mariadb
# systemctl enable mariadb
```
