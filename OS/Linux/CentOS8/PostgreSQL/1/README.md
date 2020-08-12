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
### 1行を挿入
=> insert into testtable1(id, name, age)
   values (101, 'Alice', 20)
```
```
### 複数行を挿入
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
```
 id  |  name   | age
-----+---------+-----
 102 | Bob     |  25
```
# テーブルの行を更新
## すべての行に対して更新
```
### テーブル更新前
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
### テーブル更新後
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
## 特定の行のみ更新
```
### 特定の行のみの更新
=> update testtable1
   set age = 27
   where name = 'Bob';
```
```
=> select * from testtable1;
```
```
 id  |  name   | age
-----+---------+-----
 101 | Alice   |  21
 102 | Bob     |  27
 103 | Cathy   |  23
(3 行)
```
# テーブルから行を削除
## 特定の行を削除
```
### 削除前
=> select * from testtable1;
```
```
 id  |  name   | age
-----+---------+-----
 101 | Alice   |  21
 102 | Bob     |  27
 103 | Cathy   |  23
(3 行)
```
```
### nameが'Bob'の行を削除
=> delete from testtable1
   where name = 'Bob';
```
```
### 削除後
=> select * from testtable1;
```
```
 id  |  name   | age
-----+---------+-----
 101 | Alice   |  21
 103 | Cathy   |  23
(2 行)
```
## すべての行を削除
```
### すべての行を削除
=> delete from testtable1;
```
```
 id  |  name   | age
-----+---------+-----
(0 行)
```
# テーブルを削除
```
### テーブルの削除
=> drop table testtable1;
```
```
=> select * from testtable1;
```
```
ERROR:  リレーション"testtable1"は存在しません
行 1: select * from testtable1
```
