# Sambaサーバの構築
ここでは共有を出さずに一般的な設定のみを扱うことにします。(具体的には、globalセクションのみを扱います。)
## ■ インストール
```
# yum install samba
```
## ■ バージョンの確認
```
# smbd -V
```
## ■ サービスの起動
```
# systemctl enable --now smb.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|smb.service|445/tcp||

## ■ アカウント作成
sambauserをSambaユーザに登録します。
```
# pdbedit -a sambauser
```
```
new password: <Samba用パスワード>
retype new password: <Samba用パスワード>
...
```
システム上のユーザー作成は必要ありません。  

sambauserが登録されたことを確認します。
```
# pdbedit -L
```
## ■ 主設定ファイル /etc/samba/smb.conf
### ● 設定例
#### globalセクション
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

    ### インターフェース制御(環境に応じて設定)
;   interfaces = 127.0.0.0/8 ens192
;   bind interfaces only = yes

    ### アクセス制御(環境に応じて設定)
    hosts allow = 192.168.0.0/16
    hosts deny = all

    ### プリンタ共有無効化
    load printers = no
    disable spoolss = yes

    ### ログ設定
    log file = /var/log/samba/%m.log
    log level = 5
    max log size = 50

    ### 認証設定
    security = user
    passdb backend = tdbsam
```
\*1) encrypt passwords is deprecated(samba 4.14.5>?)
#### homesセクション
各UNIXユーザとそのパスワードで認証する共有フォルダを作る場合、pdbeditコマンドを用いて既存のUNIXユーザごとにSamba用のアカウントを作成する必要があります。
```
[homes]
    ### ホームディレクトリ/home/userをエクスポート
    path=/home/%S
;   path=%H
    
    ### 
    browseable = no
    
    ### 書き込みの設定
    writable = yes
    
    ### アクセス可能ユーザを指定
;   valid users = %S
;   valid users = WORKDOMAIN\%S

    ### パーミッションを指定
    create mask 0644
    directory mask = 0755
```
※ `useradd -m -k /dev/null -c /sbin/nologin TestUser`でホームディレクトリを作成しつつskelはコピーしないユーザ作成ができます

### ● 文法チェック
```
# testparm
```
## ■ セキュリティ
### ● firewall
### ● 認証
## ■ チューニング
## ■ 設定の反映
```
# systemctl restart smb.service
```
