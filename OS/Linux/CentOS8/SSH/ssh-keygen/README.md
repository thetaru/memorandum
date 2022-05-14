# ssh-keygen
|オプション|説明|
|:---|:---|
|b|ビット長|
|f|ファイル出力先|
|m|ファイル形式|
|t|暗号タイプ|
|N|パスフレーズ|

## ■ キーペアの作成
```
ssh-keygen -b 2048 -f ~/.ssh/hoge_rsa -t rsa
```
## ■ known_hostsの公開鍵を検索
```
ssh-keygen -lv -f ~/.ssh/known_hosts -F <ホスト名>
```
## ■ known_hostsの公開鍵を削除
```
ssh-keygen -f ~/.ssh/known_hosts -R <ホスト名>
```
