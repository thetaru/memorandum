# Sambaサーバの構築
|項目|設定|
|:---|:---|
|ワークグループ|WORKGROUP|
|IPアドレス|192.168.137.1|
|共有名|Public|
|共有ディレクトリ|/data|
|認証|ユーザ名とパスワード|
|権限|RW|

## Sambaのインストール
```
# yum install samba
```
## Samba用ユーザ作成
今回の作成するユーザはログインすることを考えないためログインできないようにします。
```
# useradd -l -s /sbin/nologin -M -c "Samba user" sambauser
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
```
# vi /etc/samba/smb.conf
```
```
[global]
# ワークグループ名の指定(ドメイン名かワークグループ名をファイル共有するクライアントと揃える必要がある)
    workgroup = WORKGROUP
# NetBIOS名の指定(e.g. \\192.168.137.1\publicでアクセスできるようになる)
    netbios name = public
# ユーザー名とパスワードを使ってアクセス制御
    security = user
# パスワードを管理するデータベースを指定
    passdb backend = tdbsam
# ログ出力先
    log file = /var/log/samba/sambalog.%m
    log level = 5
    max log size = 1024
```
## Sambaの起動
```
# systemctl start smb.servce
# systemctl status smb.service
# systemctl enable smb.service
```
