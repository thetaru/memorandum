# security.confのテンプレート
匿名性を高めすぎても見れないサイトが多くなるだけなのでほどほどにしましょう。
```
# エラーページにバージョンを表示させない
httpd_suppress_version_string on

# アクセス元のIPを表示しない
forwarded_for off

# ローカルのホスト名の隠蔽
visible_hostname unknown

# Proxy経由であることを隠す(v3以上)
# HTTPヘッダーのフィールドに干渉する
## リクエストヘッダー
#request_header_access Referer deny all
request_header_access X-Forwarded-For deny all
request_header_access Via deny all
request_header_access Cache-Control deny all

## レスポンスヘッダー
#reply_header_access Referer deny all
reply_header_access X-Forwarded-For deny all
reply_header_access Via deny all
reply_header_access Cache-Control deny all
```
