# MySQLのディレクトリ変更方法
デフォルトの`/var/lib/mysql`から`/data/mysql`へお引越しします。
```
### HDD追加後、デバイスが/dev/sdbと認識されていると仮定して進めます
# fdisk /dev/sdb
```
```
...
```
```
# systemctl stop mariadb
```
```
```
# mount /dev/sdb1 /data
```
```
# vi /etc/fstab
```
```
```
### うろおぼえ
+  UUID=<UUID> /data xfs defaults 0 0
```
```
# mkdir /data/mysql
# chmod 755 /data/mysql
# chown mysql:mysql /data/mysql
# cp -pr /var/lib/mysql/* /data
```
```
# vi /etc/my.cnf.d/mariadb-server.cnf
```
```
-  datadir=/var/lib/mysql
+  datadir=/data/mysql

-  socket=/var/lib/mysql/mysql.sock
+  socket=/data/mysql/mysql.sock

```
```
# vi /etc/php.ini
```
```
-  pdo_mysql.default_socket =
+  pdo_mysql.default_socket = /data/mysql/mysql.sock

-  mysqli.default_socket =
+  mysqli.default_socket = /data/mysql/mysql.sock
```
```
# vi /etc/zabbix/zabbix-server.conf
```
```
-  # DBSocket=
+  DBSocket=/data/mysql/mysql.sock
```
```
### サービス再起動
# systemctl restart php-fpm mariadb zabbix-server
```