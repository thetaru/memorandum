# アップデート手順
基本的に変更がかかる可能性のあるコマンドはteeコマンドでログに残す。
## ■ 事前情報の確認
```sh
# ホスト名
uname -n

# ログインユーザ
id

# ロードアベレージやアップタイプなど
w

# 日付
date
```
## ■ アップデート前のパッケージ情報を取得する
```sh
apt list --installed > /tmp/packages_before.log
```
## ■ アップデートのテストをする
パッケージ一覧を更新する。
```sh
apt update
```
本番前に、何のパッケージがアップデートされるのか、依存関係は何でコケているかなどを調査する。
```sh
apt list --upgradable 2>&1 | tee upgradable_$(date +%Y%m%d).log
```
## ■ アップデートをバックグラウンドで実行する
以下のコマンドをバックグラウンドで実行する。
```sh
nohup apt upgrade -y | tee upgrade_$(date +%Y%m%d).log &
```
## ■ アップデート後にすること
アップデートされたパッケージを確認する。
```sh
apt list --installed > /tmp/packages_after.log

# アップデート前後のパッケージ差分確認
diff -u /tmp/packages_{before,after}
```
※ ホールドした(つもりの)パッケージがアップデートされていないことなどを確認する   

次に、サービスまたはシステムの再起動が必要かどうかを確認する。  
`/var/run/reboot-required`ファイルが存在すれば、システムの再起動が必要となる。
```sh
# サービスの再起動が必要であることを確認
checkrestart

# システムの再起動が必要であることを確認
ls -l /var/run/reboot-required
```
※ `update-notifier-common`と`debian-goodies`パッケージをインストールする必要がある
  
もろもろ確認したら必要に応じて、**業務影響がないことを確認**しつつサービスまたはシステムの再起動を実施する。  
  
再起動後、サーバ上で動作しているサービスが正常に動いていることを確認する。  
以下は、サービスが動いていることを確認している。
```sh
systemctl status XXX.service
```
