# ファイルをつかんでいるプロセスの特定
ファイルをつかんでいるプロセス名(とそのPID)を特定する。
```sh
lsof /var/log/hoge.log
```

取得したPIDからすべてのプロセスを列挙する。  
```sh
lsof -p xxxx
```
`/var/log/messages`のログからPIDを見つけ、上記コマンドを実行するのもよい。  
