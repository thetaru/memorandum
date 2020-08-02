# Zabbix5.0LTSをdocker-composeで構築
## ■ バージョン
```
# docker --version
```
```
Docker version 19.03.12, build 48a66213fe
```
```
# docker-compose --version
```
```
docker-compose version 1.26.2, build eefe0d31
```
## ■ 
### 構成
```
Base: CentOS7
DB: mariadb
Web: apache
```
### 手順
```
### 公式をクローン
# git clone https://github.com/zabbix/zabbix-docker
```
`zabbix-docker`内の必要なファイルのみ`zabbi-docker/zabbix-compose`に移します。  
composeファイルがたくさんありますが、今回の構成では`docker-compose_v3_centos_mysql_latest.yaml`を使用します。
```
# cd zabbix-docker/
# mkdir zabbix-compse
# cp docker-compose_v3_centos_mysql_latest.yaml ./zabbix-compose/docker-compose.yaml
# cp .env_agent .env_db_mysql .env_srv .env_web ./zabbix-compose
# cp .MYSQL_PASSWORD .MYSQL_ROOT_PASSWORD .MYSQL_USER ./zabbix-compose
```
composeファイルを編集します。  
編集前のcomposeファイルの構成は主に次のようになっています。
```
version: '3.5'
services:
  zabbix-server:
  zabbix-proxy-sqlite3:
  zabbix-proxy-mysql:
  zabbix-web-apache-mysql:
  zabbix-web-nginx-mysql:
  zabbix-agent:
  zabbix-java-gateway:
  zabbix-snmptraps:
  mysql-server:
  db_data_mysql:
networks:
secrets:
```
必要のないサービス`zabbix-proxy-sqlite3`,`zabbix-proxy-mysql`,`zabbix-web-nginx-mysql`,`zabbix-java-gateway`を削除しましょう。
