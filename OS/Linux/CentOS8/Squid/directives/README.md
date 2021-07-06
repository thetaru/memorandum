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
## ● 
## ● 
## ● 
## ● 
## ● 
## ● 
