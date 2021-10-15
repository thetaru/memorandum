# memo
ファイルで共通する行を抜き出す
```
grep -x -i -f  file1 file2
```
UID/GIDを指定したユーザー追加
```
### GID=1001のグループhogeを作成
groupadd -g 1001 hoge

### UID=1001 GID=1001のユーザーhogeを作成
useradd -u 1001 -g 1001 hoge
```
