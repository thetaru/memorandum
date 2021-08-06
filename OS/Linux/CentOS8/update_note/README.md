# アップデートするときに気を付けること
基本的に変更がかかる可能性のあるコマンドはteeコマンドでログに残します。
## ■ アップデート前のパッケージ情報を取得する
```
# rpm -qa | sort > /tmp/packages_before.log
```
## ■ アップデートのテストをする
本番前に、何のパッケージがアプデされるのか、依存関係は何でコケているかなどを調査しましょう。
```
# yum check-update --releasever=ver 2>&1 | tee check_update_$(date +%Y%m%d).log
```
rpmの場合は以下です。
```
# rpm --test <pkg> 2>&1 | tee check_update_$(date +%Y%m%d).log
```
## ■ `nohup`コマンドを使う
サーバに`teraterm`などで接続して`yum update`をしていたときに接続が切れて(切って)しまったなどの経験があるかと思います。  
以下のコマンドで裏で流せます。(セッションが途切れてもそのまま実行されます。)
```
# nohup yum -y --releasever=ver update > update_$(date +%Y%m%d).log' &
```
というかアプデに限らず長時間かかる処理を実行する際は`nohup <command> &`を使って裏で走らせましょう。
## ■ アプデ後にすること
confファイルが置き換わってないことを確認する。
```
# find / -name "*.rpmsave" -o ".rpmnew"
```
- .rpmsave

> 設定ファイルが置き換わり、既存の設定ファイルに`.rpmsave`がついているかも。 

- .rpmnew

> 設定ファイルに変更はない(コピーに等しい)  
  
アップデートされたパッケージの確認をします。
```
# rpm -qa | sort > /tmp/packages_after.log
# diff /tmp/packages_{before,after}
```
※ ここでカーネルがアップデートされていないことや変なパッケージが入り込んでいないことを確認しましょう   
  
もろもろ確認したら**業務影響がないことを確認**(冗長構成になっていて片系にしても大丈夫〜とか非機能系で全く業務に支障を及ぼさないからおけ〜ってやつを調査)しつつ再起動しましょう。  
  
再起動後、サーバ上で動作しているサービスが正常に動いていることを確認します。  
以下は、サービスが動いていることを確認しています。
```
# systemctl status XXX.service
```
