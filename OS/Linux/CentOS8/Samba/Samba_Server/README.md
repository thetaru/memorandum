# Sambaサーバの構築
ここでは共有を出さずに一般的な設定のみを扱うことにします。(具体的には、globalセクションのみを扱います。)
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
### Linux側日本語文字コード
unix charset = UTF-8

### Windows側日本語文字コード
dos charset = CP932

### 長いファイル名の文字化け対処
mangled names = no

### 上記対処でファイルアクセス不可になる一部文字の置換
vfs objects = catia

### 上記対処でファイルアクセス不可になる一部文字の置換
catia:mappings = 0x22:0xa8,0x2a:0xa4,0x2f:0xf8,0x3a:0xf7,0x3c:0xab,0x3e:0xbb,0x3f:0xbf,0x5c:0xff,0x7c:0xa6

### Windowsのワークグループ名を指定
workgroup = WORKGROUP

### アクセス制御
hosts allow = 192.168.0.0/24

### プリンタ共有無効化
load printers = no
disable spoolss = yes
```
## Sambaの起動
```
# systemctl start smb.servce
# systemctl status smb.service
# systemctl enable smb.service
```
