# ssh-keygen
## ■ キーペアの作成

## ■ known_hostsの公開鍵を検索
```
ssh-keygen -lv -f ~/.ssh/known_hosts -F <ホスト名>
```
## ■ known_hostsの公開鍵を削除
```
ssh-keygen -f ~/.ssh/known_hosts -R <ホスト名>
```
