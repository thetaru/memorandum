# セキュリティ設定
## ■ 必須設定
### `/etc/httpd/conf.d/security.conf`
```
# cat << EOF > /etc/httpd/conf.d/security.conf
# サーバ情報の隠蔽
ServerTokens Prod

# バージョン情報の隠蔽
ServerSignature Off

# PHPのバージョン情報の隠蔽
Header unset X-Powered-By

# httpoxy 対策
RequestHeader unset Proxy

# クリックジャッキング対策
Header append X-Frame-Options SAMEORIGIN

# XSS対策
Header set X-XSS-Protection "1; mode=block"
Header set X-Content-Type-Options nosniff

# XST対策
TraceEnable Off

<Directory /var/www/html>
    # .htaccess の有効化
    AllowOverride All
    # ファイル一覧出力の禁止
    Options -Indexes
</Directory>
EOF
```
### autoindex.conf
iconsの設定等が記載されているが、ディレクトリ一覧は表示させないため原則的に利用しないので削除する。  
ファイル自体を削除するとアップデート時に再作成されるので、空ファイルにする。
```
echo "" > /etc/httpd/conf.d/autoindex.conf
```
### welcome.conf
welcomeページに色々な情報がわかってしまうので削除する。  
ファイル自体を削除するとアップデート時に再作成されるので、空ファイルにする。
```
echo "" > /etc/httpd/conf.d/welcome.conf
```
## ■ 任意設定
### `/etc/httpd/conf.d/security-strict.conf`
- GET/POST 以外使えなくなる
- cgi-bin が使えなくなる
```
# cat << EOF > /etc/httpd/conf.d/security-strict.conf
# DoS 攻撃対策
LimitRequestBody 10485760
LimitRequestFields 50

# slowloris 対策
RequestReadTimeout header=20-40,MinRate=500 body=20,MinRate=500

# HTTPメソッドの制限
<Directory /var/www/html>
    Require method GET POST
</Directory>

<Directory "/var/www/cgi-bin">
    Require all denied
</Directory>
```
