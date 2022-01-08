# scoop
## ■ インストール方法
powershell上で以下を実行します。
```ps
> set-executionpolicy remotesigned -scope currentuser
> iwr -useb get.scoop.sh | iex
```
```
Scoop was installed successfully!
```

## ■ オプション
### help
```ps
> scoop help
```
### search
パッケージを検索することができます。  
パッケージ名を指定しない場合、レポジトリ(bucketなど)のすべてのパッケージが表示されます。
```
> scoop search [pkg]
```
### install
### uninstall
### list
