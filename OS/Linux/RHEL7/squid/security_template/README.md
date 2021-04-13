# security.confのテンプレート
```
# エラーページにバージョンを表示させない
httpd_suppress_version_string on

# アクセス元のIPを表示しない
forwarded_for off

# ローカルのホスト名の隠蔽
visible_hostname unknown

# ユーザーエージェントの非表示
header_access User-Agent deny all

# Proxy経由であることを隠す(Squidのバージョンが3の場合)
request_header_access X-Forwarded-For deny all
request_header_access Via deny all
request_header_access Cache-Control deny all
reply_header_access X-Forwarded-For deny all
reply_header_access Via deny all
reply_header_access Cache-Control deny all
```
