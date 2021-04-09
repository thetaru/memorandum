# キャッシュについての設定
## キャッシュ機能
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
## 特定のページをキャッシュから除外
ある特定のページをキャッシュから除外する場合は次のようにします。
```
# github.comをキャッシュしない例
acl QUERY urlpath_regex cgi-bin \? github.com
no_cache deny QUERY
```
## 短い間隔でアクセスすると、キャッシュが残りIPが切り替わらない
同じドメインに対して短い間隔で連続アクセスされた時に接続を使い回す仕様らしい。(i.e. IP分散が出来なくなってしまう)  
この現象を回避するために以下の設定が必要となります。
```
client_persistent_connections off
server_persistent_connections off
```
