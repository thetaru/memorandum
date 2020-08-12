# PostgreSQL
# INSTALL
バージョンを指定する際は注意すること。
```
# yum -y install postgresql-server
```
```
# psql --version
```
```
psql (PostgreSQL) 12.1
```
# 初期設定
## データベース初期化
```
### 各種confファイルが生成される
# postgresql-setup initdb
```
## postgresql.confの編集
```
# vi /var/lib/pgsql/data/postgresql.conf
```
```
### デフォルトはlocalhostのみlisteするので外からもlistenするようにする
-  #listen_addresses = 'localhost'
+  listen_addresses = '*'
```
```
### 接続ポート
-  #port = 5432
+  port = 10864
```
```
### ログの出力形式
-  log_line_prefix = '%m [%p] '
+  log_line_prefix = '< %t %u %d >'
```
## pg_hba.confの編集
※ もう少し細かい設定ができるので追記する予定
```
# vi /var/lib/pgsql/data/pg_hba.conf
```
```
+  "# PostgreSQL Client Authentication Configuration File"
+  "# ==================================================="
+  "local all all              trust"
+  "host  all all 127.0.0.1/32 trust"
+  "host  all all ::1/128      trust"
```
## PostgreSQL起動
```
# systemctl start postgresql
# systemctl enable postgresql
```
# 接続確認
```
# psql -U postgres
```
```
psql (12.1)
```
