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
# yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent
```
