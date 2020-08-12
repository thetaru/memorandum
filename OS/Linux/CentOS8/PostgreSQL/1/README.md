# 基本操作
# テーブルの作成
```
### テーブル作成
=> create table testtable1 (
    id integer primary key
   , name text not null unique
   , age integer
   );
```
```
### テーブルの一覧表示
=> \dt
```
```
             リレーション一覧
 スキーマ |    名前    |    型    | 所有者
----------+------------+----------+--------
 public   | testtable1 | テーブル | user1
```
# テーブルに新しい行を挿入
```
=> insert into testtable1(id, name, age)
   values (101, 'Alice', 20)
        , (102, 'Bob'  , 25)
        , (103, 'Cathy', 22);
```
# テーブルの行を検索
```
=> select * from testtable1;
```
```
 id  |  name   | age
-----+---------+-----
 101 | Alice   |  20
 102 | Bob     |  25
 103 | Cathy   |  22
(3 行)
```
