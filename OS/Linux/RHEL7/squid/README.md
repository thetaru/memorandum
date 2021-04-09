# squid
## ■ Setting
- [ ] [squid.confのテンプレート]()
## ■ Tips
- [ ] [ファイルディスクリプタの設定]()
- [ ] [キャッシュの設定]()
- [ ] [名前解決の挙動設定]()
- [ ] [OS・ブラウザの制限]()
- [ ] [カーネルパラメータの設定]()
- [ ] [ホワイトリスト・ブラックリストの設定]()

### 名前解決する際の挙動変更
```
# on  -> hostname or fqdn
# off -> fqdn Only
dns_defnames on
```
### 古いOS・ブラウザを制限
必要に応じてブラウザのバージョントークやOSのプラットフォームトークンを調べ`DenyBrowser`, `DenyOS`に登録する。
```
# define denied OS
acl DenyOS browser -i windows.95
acl DenyOS browser -i windows.98

# define denied Browser
acl DenyBrowser -i MSIE.4
acl DenyBrowser -i MSIE.5

# Deney OS/Browser
http_access deny DenyOS
http_access deny DenyBrowser

# Show Error message on Browser(※/etc/share/squid/errors/English に ERR_SECURITY_DENY ファイルを置く)
deny_info ERR_SECURITY_DENY DenyOS
deny_info ERR_SECURITY_DENY DenyBrowser
```
