# UID/GIDを指定したユーザ作成
```
# GID=1001のグループhogeを作成
groupadd -g 1001 hoge

# UID=1001 GID=1001のユーザーhogeを作成
useradd -u 1001 -g 1001 hoge

# ユーザhogeの確認
id hoge
```
