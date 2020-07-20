# rsync
## Syntax  
```
rsync [OPTION] [username@]hostname:/path/src/ /path/dest/
```
```/path/src/```: コピー元のパス ```/path/dest/```: コピー先のパス  
### :warning:注意:warning:
rsyncのパス指定において、  ```/path/to/```と```/path/to```とで意味が変わります。  
前者は```/path/to/*```を意味しますが 、後者は```/path/to```ディレクトリ自身を意味します。  
つまり、ファイルとして送られてくるかディレクトリごと送られてくるかの違いがあります。
## e.g. リモートサーバからローカルサーバへコピー
これくらいならscpコマンドでも十分です。
### 対象ファイルの確認
```
rsync -ahvn username@hostname:/path/src/ /path/dest/
```
### ファイルの転送状況の表示
```
rsync -ahv --progress username@hostname:/path/src/ /path/dest/
```
### SSHのポートを指定
```
rsync -e "ssh -p xxxx"
```
## e.g. 差分・完全バックアップ
### 完全バックアップ
バックアップ容量が小さいときはこちら
```
rsync -a --delete /path/src/ /path/dest/
```
### 差分バックアップ
バックアップ容量が大きいときはこちら
```
rsync -a --delete --link-dest=/path/link_dest/ /path/src/ /path/dest/
```
