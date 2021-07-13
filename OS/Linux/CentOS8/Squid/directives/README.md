# directives
## ● access_log (common)
### ■ Syntax
```
access_log <module>:<place> [option...] [acl...]
```

#### module
|module|place|説明|
|:---|:---|:---|
|none|-|ACLに一致するリクエストはログに記録しない|
|stdio|ログのファイルパス|すべてのリクエストをログに同期書き込みで記録する|
|daemon|ログのファイルパス|すべてのリクエストをログに非同期書き込みで記録する|
|syslog|facility.priority|syslogのファシリティとプライオリティを指定して記録する|

#### option
|option|説明|
|:---|:---|
|logformat|指定のログフォーマットでログを記録する|

※ logformatディレクティブを使用することでカスタムしたログフォーマットを設定することができる

### ■ 設定例
```
### ローカルのログファイルに記録
access_log stdio:/var/log/squid/access.log

### syslogサーバに記録
access_log syslog:local1.info
```

## ● acl (common)
### ■ Syntax
```
acl aclname acltype argument...
acl aclname acltype "file"
```
#### aclname
ACL名を指定する。  
※ ただし、ビルトインのACL名(localhostなど)もあるので注意すること

#### acltype
|acltype|説明|
|:---|:---|
|src|送信元|
|dstdomain|送信先ドメイン|
|dstdom_regex|正規表現を使用した送信先ドメイン|
|port||
|method||
|req_mime_type||
|rep_mime_type||
|snmp_community||
|any-of||
|all-of||
|proxy_auth||

### ■ 使用例
```
acl localnet src 192.168.0.0/16

acl Safe_ports port 80
acl SSL_ports port 443
acl CONNECT method CONNECT

acl whitelist dstdomain "/etc/squid/whitelist"
```

## ● always_direct
使えそうなので記載。バイパスできる
## ● auth_params (auth)
## ● cache (cache)
### ■ Syntax
```
```
### ■ 使用例
```
### キャッシュ機能を無効化する
cache deny all
```
## ● cache_dir (cache)
## ● cache_log (cache)
## ● cache_mem (cache)
## ● cache_peer (cache)
### ■ Syntax
```
cache_peer hostname type proxy-port icp-port [options]
```

#### hostname
ピアとするプロキシサーバのホスト名やIPアドレスを指定する。

#### type
|type|説明|
|:---|:---|
|parent|hostnameで指定したピアを親とする|
|sibling|hostnameで指定したピアと兄弟関係となる|

#### proxy-port
hostnameで指定したピアがHTTPリクエストをlistenするポートを指定する。

#### icp-port
hostnameで指定したプロキシサーバが利用するICPポートを指定する。  
ICPポートを利用しない場合は、0を指定すること。

#### options
主に使いそうなオプションは以下の通り。  
認証用のオプションもある。
|オプション|説明|
|:---|:---|
|ICP OPTIONS|-|
|no-query|ピアへのICPクエリを無効化する|
|PEER SELECTION METHODS|-|
|default|ピアを選出アルゴリズムで得られなかったときに使うピアを指定する|
|round-robin|ラウンドロビン方式で親プロキシをロードバランスする|
|GENERAL OPTIONS|-|
|proxy-only|ピアのキャッシュオブジェクトをローカルに保存しない|

### ■ 使用例
```
```

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
### ■ Syntax
```
dns_v4_first (on|off)
```

### ■ 使用例
```
dns_v4_first on
```

## ● follow_x_forwarded_for
xffによるアクセス制限 ここからきたやつはおけだよーてきな  
プロキシの後ろにLBがいるときに有効そう
## ● forwarded_for (security)
## ● fqdncache_size
## ● hosts_file
hostsファイルを参照する
```
hosts_file /etc/hosts
```
## ● http_access (common)
## ● http_port (common)
### ■ Syntax
```
http_port port [mode] [options]
http_port 1.2.3.4:port [mode] [options]
```
※ modeやoptionはssl bump設定時に使用するため、ここでは省略する

### ■ 設定例
```
http_port 8081
```

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
### ■ Syntax
```
icp_port icp-port
```
ICPクエリをリッスンするudpポート番号(標準では3130)を指定する。

### ■ 使用例
```
icp_port 3130
```

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
```
never_direct allow all
never_direct allow CONNECT
```
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
### ■ Syntax
```
visible_hostname hostname
```
単体プロキシサーバの動く環境では、unknownと設定してホスト名を隠蔽する。  
複数プロキシサーバの動く環境では、hostnameにどのプロキシサーバであるか識別できる文字列を設定する。  

### ■ 使用例
```
### ホスト名の非表示
visible_hostname unknown
```
