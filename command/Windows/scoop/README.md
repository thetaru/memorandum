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

## ■ よく使うオプション
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
### update
パッケージを指定する場合、パッケージのアップデートを実行します。  
パッケージを指定しない場合、scoop自体のアップデートを実行します。  
※ パッケージを指定する際にワイルドカード(\*)が使えます。
```
> scoop update [pkg]
```
### cleanup
パッケージをアップデートした場合、古いバージョンのパッケージは残るため不要な場合は削除します。  
※ パッケージを指定する際にワイルドカード(\*)が使えます。
```
> scoop cleanup <pkg>
```
### list
scoopでインストールしたパッケージを表示します。
```
> scoop list [pkg]
```

## ■ 初期設定
### bucket追加
```
> scoop install git
> scoop bucket add extras
```
### よく使うパッケージ
```
> scoop install googlechrome teraterm vim winmerge cmder-full
```
