# ZabbixのInstall
## ■ SELinuxの無効化
```
# vi /etc/selinuc/config
```
```
-  SELINUX=enforcing
+  SELINUX=disabled
```
## ■ MariaDBの設定
### Mariadbのインストール
```
# yum install mariadb-server
```
mariadbを起動します。
```
# systemctl enable --now mariadb
```
最低限のセキュリティ設定をしてくれるコマンドを実行します。
```
# mysql_secure_installation
```
データベースの設定をします。
```
# mysql -uroot -p
password(特に設定していない場合はEnterを押します。)
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> create user zabbix@localhost identified by 'password';
mysql> grant all privileges on zabbix.* to zabbix@localhost;
mysql> quit;
```
### 設定ファイルの編集
```
# vi /etc/my.cnf
```
```
```
```
# vi /etc/my.cnf.d/
```
```
```
## ■ apacheの設定
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/apache)を参考にしてください。
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
## ■ サービスの起動
```
# systemctl enable --now mariadb
```
