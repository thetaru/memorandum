# ssh
## ■ シンタックス
```
ssh [オプション] [ユーザ名@]ホスト名 [コマンド]
```
## ■ 便利なオプション
|オプション|説明|
|:---|:---|
|-4|IPv4のみを使用する|
|-i|公開鍵ファイルを指定する|
|-c|cipherを指定する|
|-m|macを指定する|
|-o|設定パラメータを指定する(下記参照)|

## ■ おぼえておくべきパラメータ
### StrictHostKeyChecking
ホスト鍵のチェック方法を指定します。
|設定値|説明|
|:---|:---|
|ask||
|yes||
|no||

### UserKnownHostsFile
|設定値|説明|
|:---|:---|
|||

## ■ Tips
### 警告メッセージを出さないようにする
```
# ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null [ユーザ名@]ホスト名
```
### SSHがサポートする暗号方式を確認する
```
# ssh -Q cipher
```
### SSHがサポートするハッシュアルゴリズムを確認する
```
# ssh -Q mac
```
