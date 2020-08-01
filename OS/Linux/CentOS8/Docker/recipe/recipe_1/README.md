# RECIPE 1
## ■ 前提条件
```
# cat /etc/redhat-release
```
```
CentOS Linux release 8.2.2004 (Core)
```
```
# uname -r
```
```
4.18.0-193.6.3.el8_2.x86_64
```
```
# docker version
```
```
...
 Version:           19.03.12
...
```
|ホスト名|IPアドレス|
|:---|:---|
|docker-zabbix|192.168.137.2|
|docker-nginx|192.168.137.3|
## ■ 目標
```
ここにイメージが入る予定
```
## ■ ベースイメージ作成
```
```
## ■ nginxサーバ構築
```
```
## ■ Zabbixサーバ構築
### zabbix serverコンテナ作成
```
### コンテナの作成
# docker container run -d -it -p 10051:10051 --name zbx-srv --hostname zbx-srv --privileged centos:base /sbin/init
```
```
### コンテナに入る
# docker exec -it zbx-srv /bin/bash
```
```
### zabbixリポジトリのインストール
 # rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
```
```
# yum -y install zabbix-server-mysql mariadb-server
```
### web コンテナ作成
```
### コンテナの作成
# docker run -d -it -p 80:80 --name zbx-web --hostname zbx-web --privileged centos:base /sbin/init
```
```
### コンテナに入る
# docker exec -it zbx-web /bin/bash
```
```
### zabbixリポジトリのインストール
 # rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-2.el7.noarch.rpm
```
```
# yum -y install zabbix-web-mysql zabbix-web-japanese
```
```
### timezoneの設定
# sed -i 's|# php_value date.timezone Europe/Riga|php_value date.timezone Asia/Tokyo|' /etc/httpd/conf.d/zabbix.conf
```
```
### httpサービスの起動・自動起動の有効化
# systemctl start httpd
# systemctl enable httpd
```
### DB コンテナの作成
```
# docker container run -d -it --name zbx-db --hostname zbx-db --privileged centos:base /sbin/init
```
```
# docker exec -it zbx-db /bin/bash
```
```
# yum -y install mariadb-server
```
```
# vi /etc/my.cnd.d/server.cnf
```
```
[mysqld]
+  character-set-server = utf8
+  collation-server     = utf8_bin
+  skip-character-set-client-handshake
+  innodb_file_per_table

```
```
# vi /etc/my.cnf
```
```
[mysqld]
...
+  user=mysql
+  innodb_file_per_table
+  innodb_autoextend_increment = 1
+  innodb_file_format=Barracuda
+  innodb_buffer_pool_size = 1024M
+  innodb_thread_concurrency = 16
+  innodb_flush_log_at_trx_commit=2
+  innodb_log_buffer_size = 32M
+  innodb_log_file_size = 1024M
+  innodb_checksums = 0
+  innodb_doublewrite = 0
```
### network作成
```
```
```
# docker network connect zbx-nw zbx-db
# docker network connect zbx-nw zbx-srv
# docker network connect zbx-nw zbx-web
```
