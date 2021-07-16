# digdagサーバの構築
## ■ 事前準備
### ● ユーザ/グループ作成
```
# groupadd digdag
# useradd -M -g digdag -s /sbin/nologin digdag
```

## ■ インストール
### ● digdagのインストール
```
# curl -o /usr/local/bin/digdag --create-dirs -L "https://dl.digdag.io/digdag-latest"
# chmod +x /usr/local/bin/digdag
# echo 'export PATH="/usr/local/bin/digdag:$PATH"' >> ~/.bashrc
# source ~/.bashrc
```

### ● javaのインストール
```
# yum install java
```

### ● PostgreSQLのインストール
```
# yum install postgresql-server
# yum install postgresql-contrib
```

## ■ PostgreSQLの設定
```
# postgresql-setup  --initdb
```
```
# systemctl enable --now postgresql.service
# systemctl status postgresql.service
```
```
# su - postgres
$ psql
postgres=# alter user postgres with password 'PASSWORD';
postgres=# \q
$ exit
```
```
# vi /var/lib/pgsql/data/pg_hba.conf
```
```
# "local" is for Unix domain socket connections only
-  local   all             all                                     peer
+  local   all             all                                     md5
# IPv4 local connections:
-  host    all             all             127.0.0.1/32            ident
+  host    all             all             127.0.0.1/32            md5
# IPv6 local connections:
-  host    all             all             ::1/128                 ident
+  host    all             all             ::1/128                 md5
```
```
# systemctl restart postgresql.service
```
```
# psql -U postgres
postgres=# CREATE ROLE digdag WITH PASSWORD 'PASSWORD' NOSUPERUSER NOCREATEDB NOCREATEROLE LOGIN;
postgres=# CREATE DATABASE digdag_db WITH OWNER digdag;

postgres=# \c digdag_db;
postgres=# CREATE EXTENSION "uuid-ossp";
postgres=# \q
```
```
# psql -U digdag -d digdag_db
postgres=# select installed_version from pg_catalog.pg_available_extensions where name = 'uuid-ossp';
postgres=# \q
```
```
# mkdir /etc/digdag
```
```
# vi /etc/digdag/digdag.properties
```
```
database.type = postgresql
database.host = localhost
database.port = 5432
database.user = digdag
database.password = PASSWORD
database.database = digdag_db
database.maximumPoolSize = 20
```
```
# vi /etc/sysconfig/digdag-server
```
```
# configuration file for PostgreSQL
CONFIG_FILE=/etc/digdag/digdag.properties

# port number for web service (port をデフォルトから変えると push できない)
PORT=65432

# binding address (default: 127.0.0.1)
BINDING=0.0.0.0

# log file
ACCESS_LOG=/var/log/digdag-server/access
TASK_LOG=/var/log/digdag-server/task
```
```
# vi /usr/lib/systemd/system/digdag-server.service
```
```
[Unit]
Description=Digdag server daemon
After=network.target postgresql.service

[Service]
User=digdag
Group=digdag
EnvironmentFile=/etc/sysconfig/digdag-server
ExecStart=/usr/bin/java -jar /usr/local/bin/digdag server -n ${PORT} -b ${BINDING} -O ${TASK_LOG} -A ${ACCESS_LOG} -c ${CONFIG_FILE}
ExecStop=/bin/kill -s SIGTERM ${MAINPID}

[Install]
WantedBy=multi-user.target
```
```
# systemctl daemon-reload
```
```
# mkdir -p /var/log/digdag-server/access /var/log/digdag-server/task
# chown -R bigdata:bigdata /var/log/digdag-server
```
```
# systemctl restart digdag-server
# systemctl status digdag-server
```
## ■ バージョンの確認
```
# digdag --version
```
## ■ サービスの起動
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||||

## ■ 事前準備系(特になければ消してok)

## ■ 主設定ファイル xxx.conf
### ● xxxセクション
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ロギング
## ■ チューニング
## ■ 設定の反映
## ■ 設定の確認
