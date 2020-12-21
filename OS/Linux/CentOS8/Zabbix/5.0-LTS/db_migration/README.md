# MariaDB(MySQL)の移行
MariaDBのデータ領域はデフォルトの設定では`/var/lib/mysql`です。  
しかし、特定のパーティションをMySQLのデータ領域として使用したい場合があります。
## ■ 手順
```
### HDD追加後、デバイスが/dev/sdbと認識されていると仮定して進めます
# fdisk /dev/sdb

### 
# mkfs.xxx /dev/sdb
```
```
# systemctl stop mariadb
```
```
# mount /dev/sdb1 /data
```
### fstabの編集
```
# vi /etc/fstab
```
```
### うろおぼえ
+  UUID=<UUID> /data xfs defaults 0 0
```
### 移行先の権限設定
```
# mkdir /data/mysql
# chmod 755 /data/mysql
# chown mysql:mysql /data/mysql
# cp -pr /var/lib/mysql/* /data/mysql
```
### mariadb-server.cnfの設定
```
# vi /etc/my.cnf.d/mariadb-server.cnf
```
```
-  datadir=/var/lib/mysql
+  datadir=/data/mysql

-  socket=/var/lib/mysql/mysql.sock
+  socket=/data/mysql/mysql.sock
```
### php.iniの設定
```
# vi /etc/php.ini
```
```
-  pdo_mysql.default_socket =
+  pdo_mysql.default_socket = /data/mysql/mysql.sock

-  mysqli.default_socket =
+  mysqli.default_socket = /data/mysql/mysql.sock
```
### zabbix-server.confの設定
```
# vi /etc/zabbix/zabbix-server.conf
```
```
-  # DBSocket=
+  DBSocket=/data/mysql/mysql.sock
```
### サービスの再起動
```
### サービス再起動
# systemctl restart php-fpm mariadb zabbix-server
```
