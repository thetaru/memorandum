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
[global]
# ワークグループ名の指定(ドメイン名かワークグループ名をファイル共有するクライアントと揃える必要がある)
    workgroup = WORKGROUP
# アクセス制限
    hosts allow = 127. 192.168.137.
# NetBIOS名の指定(e.g. \\192.168.137.1\shareでアクセスできるようになる)
    netbios name = SAMBA
# ログ出力先
    log file = /var/log/samba/sambalog.%m
    log level = 5

# 残りのセクションはやりたいことに依存するので省略する
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
