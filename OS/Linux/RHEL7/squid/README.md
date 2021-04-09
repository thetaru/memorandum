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

## ■ 個別設定
### 特定のページをキャッシュから除外
ある特定のページをキャッシュから除外する場合
```
# github.comをキャッシュしない例
acl QUERY urlpath_regex cgi-bin \? github.com
no_cache deny QUERY
```
### キャッシュ機能
```
# キャッシュのメモリサイズ
cache_mem 8 MB

# メモリの格納するオブジェクトの最大サイズ
maximum_object_size_in_memory 8 KB

# キャッシュする最大オブジェクトサイズ
maximum_object_size 20480 KB

# FQDNの最大キャッシュ数
fqdncache_size 1024

# キャッシュの保存先(100MBの容量を16分割しそれぞれに256のフォルダが切られその中にキャッシングされる)
cache_dir ufs /var/spool/squid 100 16 256
```
### ファイルディスクリプタ数の設定
```
# I/Oが多いなら気持ち多めに設定する
max_filedesc 8192
```
### 短い間隔でアクセスすると、キャッシュが残りIPが切り替わらない
同じドメインに対して短い間隔で連続アクセスされた時に接続を使い回す仕様らしい。(i.e. IP分散が出来なくなってしまう)  
この現象を回避するために以下の設定が必要となります。
```
client_persistent_connections off
server_persistent_connections off
```
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
