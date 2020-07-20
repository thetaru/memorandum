# rsync
## Syntax  
```
rsync [OPTION] [username@]hostname:src dest
```
src: コピー元のパス dest: コピー先のパス  
:warning:注意事項:warning:
### e.g. リモートサーバからローカルサーバへコピー
これくらいならscpコマンドでも十分です。
#### 対象ファイルの確認
```
rsync -ahvn username@hostname:src/* dest
```
#### ファイルの転送状況の表示
```
rsync -ahv --progress username@hostname:src/* dest
```
#### SSHのポートを指定
```
rsync -e "ssh -p xxxx"
```
### e.g. 差分・完全バックアップ
```
rsync -a --delete src/ dest/
```
