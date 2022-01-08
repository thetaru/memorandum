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
オプションの一覧が表示されます。
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
パッケージ名を指定し、インストールします。
```
> scoop install <pkg>
```
### uninstall
パッケージ名を指定し、アンインストールします。
```
> scoop uninstall <pkg>
```
### list
scoopでインストールしたパッケージを表示します。
```
> scoop list [pkg]
```
