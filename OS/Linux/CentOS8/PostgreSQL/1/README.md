# 基本操作
# テーブル作成
```
### SQLファイルを作り流し込みます
# vi create-testtable.sql
```
```
+  create table testtable1 (
+    id integer primary key
+  , name text not null unique
+  , age integer
+  );
```
```
### ユーザ:uesr1でDB:testdb1にアクセス
# psql -U user1 testdb1
```
