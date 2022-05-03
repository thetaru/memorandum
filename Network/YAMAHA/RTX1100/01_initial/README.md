# 初期設定
コンソールケーブルで接続する。  
ボーレートは`9600`、ストップビットは`8-N-1`に設定する。

## ■ 文字コードの変更
```
> console character ascii
```

## ■ パスワードの変更
administratorに昇格して以下のコマンドを実行する。
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

## ■ タイムゾーンの設定
```
# timezone jst
```

## ■ 設定の保存
```
# save
```
