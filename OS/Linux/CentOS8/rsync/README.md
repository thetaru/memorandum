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
これくらいならscpコマンドで十分です。
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
```/path/link_dest```オプションをつけると、バックアップ時に変更のないファイルが```/path/link_dest/```と```/path_dest/```で共有されます。
### cronによるバックアップ
cronを使ってバックアップを定期実行します。
バックアップのシェル```backup.sh```はこんな感じにします。
```
#!/bin/bash
SRC=/path/src/
DEST=/path/dest/$(date "+%Y%m%d-%H%M%S")
SSH_TO=user@hostname
rsync -a --delete -e ssh $SRC $SSH_TO:$DEST
```
このシェルだと```/path/dest/```配下に日時のついたディレクトリにコピー元の全ファイルがバックアップされることになります。
```
# vi /etc/crontab
```
```
30 4 * * 6 root COMMAND=/path/to/backup.sh
```
## オプション
|オプション|意味|
|:---:|:---:|
|-a|-rlptgoD相当|
|-r|指定ディレクトリ配下をすべて対象とする|
|-l|シンボリックリンクをそのままシンボリックリンクとしてコピー|
|-p|パーミッションをそのままコピー|
|-t|タイムスタンプをそのままコピー|
|-g|グループをそのままコピー|
|-o|ファイル所有者をそのままコピー (root のみ有効)|
|-H|ハードリンクをそのまま反映|
|-h|ファイルサイズのbytesをKやMで出力|
|-v|コピーしたファイル名やバイト数などの転送情報を出力|
|-z|データ転送時に圧縮|
|-u|転送先に既にファイルが存在し、転送先のタイムスタンプの方が新しい場合は転送しない|
|-n|コピーや転送を実際には行わず転送内容のみ出力|

