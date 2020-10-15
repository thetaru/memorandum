# セキュリティ設定
## 必須設定
```
# cat << EOF > /etc/httpd/conf.d/security.conf
# バージョン情報の隠蔽
ServerTokens Prod 
Header unset "X-Powered-By"
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
## 任意設定
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
