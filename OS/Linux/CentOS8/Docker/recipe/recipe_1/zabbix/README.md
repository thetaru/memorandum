# Zabbix 5.0LTS を docker-compose で構築
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
## ■ 構成
```
Base: CentOS7
DB: mariadb
Web: apache
```
## ■ 手順
### git clone
```
# git clone https://github.com/zabbix/zabbix-docker
```
### ファイルの選択
`zabbix-docker`内の必要なファイルのみ`zabbi-docker/zabbix-compose`に移します。  
composeファイルがたくさんありますが、今回の構成では`docker-compose_v3_centos_mysql_latest.yaml`を使用します。
```
# cd zabbix-docker/
# mkdir zabbix-compse
# cp docker-compose_v3_centos_mysql_latest.yaml ./zabbix-compose/docker-compose.yaml
# cp .env_agent .env_db_mysql .env_srv .env_web ./zabbix-compose
# cp .MYSQL_PASSWORD .MYSQL_ROOT_PASSWORD .MYSQL_USER ./zabbix-compose
```
### composeファイルの編集
編集前のcomposeファイルの簡素化した構成は次のようになっています。
```
version: '3.5'
services:
  zabbix-server:
  zabbix-proxy-sqlite3:     <- いらない
  zabbix-proxy-mysql:       <- いらない
  zabbix-web-apache-mysql:
  zabbix-web-nginx-mysql:   <- いらない
  zabbix-agent:
  zabbix-java-gateway:      <- いらない
  zabbix-snmptraps:
  mysql-server:
  db_data_mysql:
networks:
secrets:
```
必要のないサービス`zabbix-proxy-sqlite3`,`zabbix-proxy-mysql`,`zabbix-web-nginx-mysql`,`zabbix-java-gateway`を削除しましょう。  
また、全サービスの`deploy`ディレクティブも必要ないので削除します。  
最終的に、[これ](https://github.com/thetaru/memorandum/blob/master/OS/Linux/CentOS8/Docker/recipe/recipe_1/zabbix/docker-compose.yaml)と同じになっているはずです。  
### DBの認証設定 
composeファイルは`.MYSQL_PASSWORD`,`.MYSQL_ROOT_PASSWORD`,`.MYSQL_USER`を読み込んでいます。
### 環境変数の設定
環境変数ファイルを編集します。
```
# vi .env_web
```
```
-  ZBX_SERVER_NAME=Composed installation
+  ZBX_SERVER_NAME=<任意の名前>
```
```
-  # PHP_TZ=Europe/Riga
+  PHP_TZ=Asia/Tokyo
```
