# Samba
# ■ Sambaサーバ
## Sambaのインストール
```
# yum install samba
```
## Samba用ユーザ作成
今回の作成するユーザはログインすることを考えないためログインできないようにします。
```
# useradd -s /sbin/nologin sambauser
# passwd sambauser
```
作成したユーザをSambaユーザに登録します。
```
# pdbedit -a sambauser
```
```
new password: <Samba用パスワード>
retype new password: <Samba用パスワード>
...
```
登録されていることを確認します。
```
# pdbedit -L
```
## Sambaサーバの設定
共有するディレクトリを作成します。
```
# mkdir /share
```
```
# vi /etc/samba/smb.conf
```
```
# globalセクションで設定した設定は他セクションに対しても同様に働きます
[global]
# ワークグループ名の指定(ドメイン名かワークグループ名をファイル共有するクライアントと揃える必要がある)
    workgroup = WORKGROUP
# NetBIOS名の指定(e.g. \\192.168.137.1\shareでアクセスできるようになる)
    netbios name = samba
# ユーザー名とパスワードを使ってアクセス制御
    security = user
# パスワードを管理するデータベースを指定
    passdb backend = tdbsam
# ログ出力先
    log file = /var/log/samba/sambalog.%m
    log level = 5
    max log size = 1024

# 残りのセクションはやりたいことに依存するので省略する
# e.g.
#・接続制限(ユーザ, グループ, IPアドレスなど)
#・アクセス制御(ユーザ毎、グループ毎など)
#・読み書き設定(RO, RWなど)
```
## Sambaの起動
```
# systemctl start smb.servce
# systemctl status smb.service
# systemctl enable smb.service
```
# ■ Sambaクライアント
https://qiita.com/hana_shin/items/e768ef63bdeeef3ada39  
https://www.rem-system.com/samba-access-setting-01/
