# PostgreSQLのインストール
## 2.1 Dockerで使う
### ■ コンテナを起動する
```
### PostgreSQL ver11の公式イメージを取得
$ docker pull postgres:11

### コンテナをバックグラウンド起動
$ docker run --name posgre11 -d -e POSTGRES_PASSWORD=pass11 postgres:11

### コンテナが起動していることを確認
$ docker container ls
```
### ■ データベースを作成
```
### コンテナにアクセス
$ docker exec -it posgre11 /bin/bash

### 各種コマンドがあることを確認
$ which psql createuser createdb

### データベースユーザ"user1"を作成
$ createuser -U postgres user1

### 作成されたことを確認
$ psql -U postgres -c '\du'

### データベース"testdb1"を作成
$ createdb -U postgres -O user1 -E UTF8 --locale=C -T template0 testdb1

### 作成されたことを確認
$ psql -U postgres -l
```
データベースユーザ"user1"とデータベース"testdb1"が作成できました。  
アクセスできることを確認します。
```
### 作成したデータベースユーザで作成したデータベースにアクセス
$ psql -U user1 testdb1

### 簡単なSQLが実行できることを確認
testdb1=> select current_date;

### psqlコマンドを抜ける
testdb1=> \q
```
これでSQLが実行できるようになりました。
