# directives
## ● access_log (common)
|デフォルト値|対応バージョン|
|:---|:---|
|||

### 設定例
```
access_log /var/log/squid/access.log
```

## ● acl (common)
#### Syntax
```
acl aclname acltype argument...
acl aclname acltype "file"
```
|acltype|説明|
|:---|:---|
|src||
|dstdomain||
|dstdom_regex||
|port||
|method||
|req_mime_type||
|rep_mime_type||
|snmp_community||
|any-of||
|all-of||
|proxy_auth||

## ● always_direct
使えそうなので記載。バイパスできる
## ● auth_params (auth)
## ● cache (cache)
## ● cache_dir (cache)
## ● cache_log (cache)
## ● cache_mem (cache)
## ● cache_peer (cache)
#### Syntax
```
cache_peer hostname type http_port icp-port [options]
```

|type|説明|
|:---|:---|
|parent|hostnameで指定したプロキシサーバを親とする|
|sibling|hostnameで指定したプロキシサーバと兄弟関係となる|


プロキシサーバ同士で親子関係または兄弟関係を結ぶ時につかいます。  
  
parentで設定すると、親プロキシに問い合わせを転送し、そこからデータを受けとることになります。  
また、親プロキシ側でキャッシュにヒットした場合はそのデータを返します。  
  
siblingで設定すると、兄弟プロキシに問い合わせを転送し、キャッシュにヒットした場合はそのデータを返します。  
ヒットしなかった場合は、転送元プロキシ自身がデータをとりにいきます。  

## ● cache_peer_access (cache)
親プロキシが複数ある場合の、アクセス制御ができます(正確ではない、、、  
※ 親プロキシの振り分けは重要だよねー

## ● cache_store_log (cache)
## ● client_lifetime
## ● client_persistent_connections
## ● coredump_dir (common)
## ● dns_defnames
名前解決にsearch/domainを使用できる
## ● dns_nameservers
## ● dns_v4_first (common)
## ● follow_x_forwarded_for
xffによるアクセス制限 ここからきたやつはおけだよーてきな
## ● forwarded_for (security)
## ● fqdncache_size
## ● hosts_file
hostsファイルを参照する
```
hosts_file /etc/hosts
```
## ● http_access (common)
## ● http_port (common)
## ● http_reply_access
クライアントへのレスポンスを制限できます。  
主にMIMEタイプの制限などに使用される？
```
acl deny_mime_type rep_mime_type ^video

http_reply_access deny deny_mime_type
```
## ● httpd_suppress_version_string (security)
## ● icp_acess (cache)
ICPリクエストをする他プロキシサーバを制限します。
## ● icp_port (cache)
ICPリクエストをリッスンするudpポート番号を指定する
## ● ipcache_high (cache)
ipcache_sizeで指定した最大保存アドレス数と実際に保存しているアドレス数の百分率がipcache_highで指定した値を越えたらその値がipcache_lowになるまで古いアドレスから削除する。
## ● ipcache_low (cache)
同上
## ● ipcache_size (cache)
squidが名前解決した結果をメモリ上に保存するアドレスの最大数を指定する。
## ● logfile_rotate
ログの世代数(間隔はdaily)を設定する。  
ここで設定したならば`squid -k rotate`コマンドを実行しないといけない。  
※ logrotatedでいいと思う
## ● logformat (log)
## ● max_filedescriptors
## ● maximum_object_size (cache)
ディスク上にキャッシュされるオブジェクトの最大サイズ(byte)を指定する。  
※ あくまで１つのオブジェクトの最大容量を指定するだけなことに注意
## ● maximum_object_size_in_memory (cache)
メモリ上にキャッシュされるオブジェクトの最大サイズ(byte)を指定する。  
指定したサイズより大きいオブジェクトはメモリにはキャッシュされません(?)。
## ● memory_cache_mode (cache)
メモリにキャッシュするオブジェクトを制御します。
- always
最近取得したオブジェクトをメモリにキャッシュします。

- disk
ディスクのキャッシュで(少なくとも一度)ヒットしたオブジェクトをメモリにキャッシュします。

- network
ネットワーク経由で取得したオブジェクトのみメモリにキャッシュします。
## ● minimum_object_size (cache)
ディスク上にキャッシュされるオブジェクトの最小サイズ(byte)を指定する。  
※ メモリにはされる...ってコト！？
## ● miss_access (cache)
自身を親とする子プロキシサーバからのアクセスを制御します。
## ● never_direct
指定されたドメインへのリクエストは必ず親プロキシサーバに転送します。
## ● nonhierarchical_direct
onの場合、リクエストを直接送信します。  
offの場合、親プロキシに転送します。  
※ 障害などで親プロキシがいなくなった場合に使えそう  
もっとくわしく！
## ● prefer_direct
onの場合、はじめに直接接続を試みて、失敗したら親プロキシを使います。  
offの場合、親プロキシで接続を試みます。  
※ offのとき、親で失敗したら直でいく？
## ● request_header_access (security)
## ● server_persistent_connections
## ● snmp_access (monitoring)
## ● snmp_port (monitoring)
## ● strip_query_terms (log)
urlからクエリ用語が一部抜ける
## ● visible_hostname (security)
