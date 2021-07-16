# 統計情報の確認
## ■ socatコマンドのインストール
```
# yum install socat
```

## ■ 確認方法
```
# socat stdin /var/run/haproxy/admin.sock
show info
```
