# 初期設定
RTX1100は、初期設定時にIPアドレス192.168.100.1/24が振られている。  
クライアントマシンに適当なIPアドレスを振り、`LAN1`に有線接続した後、Telnetで192.168.100.1にアクセスする。

## ■ 文字コードの変更
```
> console character ascii
```

## ■ パスワードの変更
### ログインパスワード
```
# login password
```
```
Old_Password: 
New_Password: 
New_Password: 
```
### administratorパスワード
```
# administrator password
```
```
Old_Password: 
New_Password: 
New_Password: 
```

## ■ タイムアウト時間の変更
デフォルトでは、無操作時間が300秒続くと強制ログアウトするので変更する。
```
# login timer <sec>
```

## ■ 設定の保存
```
# save
```
