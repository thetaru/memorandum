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
### テーブルの行をすべて検索
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
```
### 行を指定した検索
=> select name, age from testtable1
   where name = 'Bob';
```
# テーブルの行を更新
```
### テーブルの行をすべて検索
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
```
=> update testtable1
   set age = age + 1;
```
```
### テーブルの行をすべて検索
=> select * from testtable1;
```
```
 id  |  name   | age
-----+---------+-----
 101 | Alice   |  21
 102 | Bob     |  26
 103 | Cathy   |  23
(3 行)
```
