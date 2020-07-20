# rsync
## Syntax  
```
rsync [OPTION] [username@]hostname:/path/src/ /path/dest
```
```/path/src/```: コピー元のパス ```/path/dest```: コピー先のパス  
### :warning:注意:warning:
rsyncの**コピー元の**パス指定において、  ```/path/to/```と```/path/to```とで意味が変わります。  
前者は```/path/to/*```を意味しますが 、後者は```/path/to```ディレクトリ自身を意味します。  
つまり、ファイルとして送られてくるかディレクトリごと送られてくるかの違いがあります。
## e.g. リモートサーバからローカルサーバへコピー
これくらいならscpコマンドで十分です。
### 対象ファイルの確認
```
# rsync -ahvn username@hostname:/path/src/ /path/dest/
```
### ファイルの転送状況の表示
```
# rsync -ahv --progress username@hostname:/path/src/ /path/dest/
```
### SSHのポートを指定
```
# rsync -e "ssh -p xxxx"
```
## e.g. 差分・完全バックアップ
### ミラーリング
```
# rsync -avh --delete /path/src/ /path/dest/
```
### 完全バックアップ
```
# rsync -a --delete /path/src/ /path/dest/
```
### 差分バックアップ
```
# rsync -a --delete --link-dest=/path/link_dest/ /path/src/ /path/dest/
```
```/path/link_dest```オプションをつけると、バックアップ時に変更のないファイルが```/path/link_dest/```と```/path_dest/```で共有されます。
### 増分バックアップ(世代管理あり)
```--link-dest```が1つ前のバックアップを指すようにすると、世代管理ありの増分バックアップになります。  
以下のようにスクリプトを作成して定期実行すれば増分バックアップとなります。
```
BASEDIR=/path/link_dest/ # バックアップ先の親ディレクトリ
LASTBACKUP=$(ls $BASEDIR | grep backup- | tail -n 1) # 1つ前のバックアップディレクトリ名
rsync -avh --link-dest=$BASEDIR/$LASTBACKUP/ /path/src/ $BASEDIR/backup-$(date "+%Y%m%d-%H%M%S")
```
### [Option]cronによるバックアップ
cronを使ってバックアップを定期実行します。
バックアップのシェル```backup.sh```はこんな感じにします。
```
#!/bin/bash
SRC=/path/src/
DEST=/path/dest/$(date "+%Y%m%d-%H%M%S")/
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
### [Option]バックアップのローテーション
以下のようなスクリプトを作成してcronで定期実行します。
```
#!/bin/bash
Backup=/path/backup/ # バックアップ先の親ディレクトリ
Save=7 # 保存期間(好きに変えてください)
Date=`date "+%s"` # 現在日時
for item in `ls $Backup`
do
  LastUpdate=`date "+%s" -r $Backup/$item` # ファイルの更新日
  Diff=$((($Date - $LastUpdate) / 86400)) # 経過日時
  if [[ $Diff -ge $Save ]]; then
    rm -f $Backup/$item
  fi
done
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
|--delete|転送元に存在しないファイルは削除|
|--link-dest|指定されたディレクトリ内と転送元のディレクトリ内の差分をコピー|
