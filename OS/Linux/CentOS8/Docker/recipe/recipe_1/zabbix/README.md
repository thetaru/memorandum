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
```
Base: CentOS7
DB: mariadb
Web: apache
```
```
### 公式をクローン
# git clone https://github.com/zabbix/zabbix-docker
```
`zabbix-docker`内の必要なファイルのみ`zabbi-docker/zabbix-compose`に移します。
```
# cd zabbix-docker/
# mkdir zabbix-compse
# cp .env_agent .env_db_mysql .env_srv .env_web ./zabbix-compose
# cp .MYSQL_PASSWORD .MYSQL_ROOT_PASSWORD .MYSQL_USER ./zabbix-compose
```
