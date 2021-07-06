# directives
## ● access_log
|デフォルト値|対応バージョン|
|:---|:---|
|||

### 設定例
```
access_log /var/log/squid/access.log
```

## ● acl
## ● always_direct
使えそうなので記載。バイパスできる
## ● cache
## ● cache_dir
## ● cache_log
## ● cache_mem
## ● client_lifetime
## ● client_persistent_connections
## ● coredump_dir
## ● dns_defnames
名前解決にsearch/domainを使用できる
## ● dns_nameservers
## ● dns_v4_first
## ● follow_x_forwarded_for
xffによるアクセス制限 ここからきたやつはおけだよーてきな
## ● forwarded_for
## ● fqdncache_size
## ● hosts_file
hostsファイルを参照する
```
hosts_file /etc/hosts
```
## ● http_access
## ● http_port
## ● http_reply_access
クライアントへのレスポンスを制限できます。  
主にMIMEタイプの制限などに使用される？
```
acl deny_mime_type rep_mime_type ^video

http_reply_access deny deny_mime_type
```
## ● httpd_suppress_version_string
## ● icp_acess
ICPリクエストを受ける兄弟プロキシサーバを制限します。
## ● icp_port
ICPリクエストをリッスンするudpポート番号を指定する
## ● ipcache_high
ipcache_sizeで指定した最大保存アドレス数と実際に保存しているアドレス数の百分率がipcache_highで指定した値を越えたらその値がipcache_lowになるまで古いアドレスから削除する。
## ● ipcache_low
同上
## ● ipcache_size
squidが名前解決した結果をメモリ上に保存するアドレスの最大数を指定する。
## ● logfile_rotate
ログの世代数(間隔はdaily)を設定する。  
ここで設定したならば`squid -k rotate`コマンドを実行しないといけない。  
※ logrotatedでいいと思う
## ● logformat
## ● max_filedescriptors
## ● maximum_object_size
オンディスクなキャッシュがキャッシュできるオブジェクトの最大容量を指定する。  
※ あくまで１つのオブジェクトの最大容量を指定するだけなことに注意
## ● maximum_object_size_in_memory
オンメモリなキャッシュがキャッシュできるオブジェクトの最大容量を指定する。  
指定したサイズより大きいオブジェクトはメモリにはキャッシュされません(?)。
## ● memory_cache_mode
メモリにキャッシュするオブジェクトを制御します。
- always
最近取得したオブジェクトをメモリにキャッシュします。

- disk
オンディスクのキャッシュで(少なくとも一度)ヒットしたオブジェクトをメモリにキャッシュします。

- network
ネットワーク経由で取得したオブジェクトのみメモリにキャッシュします。
## ● 
## ● 
## ● 
## ● 
## ● 
## ● 
## ● 
## ● 
## ● 
## ● 
## ● 
## ● 
