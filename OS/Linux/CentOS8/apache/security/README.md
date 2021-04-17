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

# 使用可能なリクエストヘッダを設定する。
Header set Access-Control-Allow-Headers "Content-Type"  

# アクセスを許可するOriginのURL。*で指定なし
Header set Access-Control-Allow-Origin "*"  

# キャッシュを残さないようにするため。
Header append Pragma no-cache

# リクエスト、レスポンスを一切保存しないため。
Header append Cache-Control no-store

# オリジンサーバの確認無しにキャッシュを利用させないため。
Header append Cache-Control no-cache

# リクエストごとに毎回完全なレスポンスを利用するため。
Header append Cache-Control must-revalidate

# XSSフィルターを有効化し、XSS検出時にページのレンダリングを停止させるため。
Header set X-XSS-Protection "1; mode=block"

# XSS対策のため、常にレスポンスヘッダからContentTypeを優先して指示する。
Header set X-Content-Type-Options nosniff

# XST対策
TraceEnable Off

# クリックジャッキング対策ためのフレーム内でのページ表示表示を一切許可しない。
Header append X-FRAME-OPTIONS "DENY"

# 大量のアクセスが来た際に、サーバ負荷をあげないため。
ListenBacklog 511   

# PHPに関するHTTP_PROXYの脆弱性について対策するため。
RequestHeader unset Proxy
EOF
```
### autoindex.conf
iconsの設定等が記載されているが、ディレクトリ一覧は表示させないため原則的に利用しないので削除する。  
ファイル自体を削除するとアップデート時に再作成されるので、空ファイルにする。
```
# echo "" > /etc/httpd/conf.d/autoindex.conf
```
### welcome.conf
welcomeページに色々な情報がわかってしまうので削除する。  
ファイル自体を削除するとアップデート時に再作成されるので、空ファイルにする。
```
# echo "" > /etc/httpd/conf.d/welcome.conf
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
