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
|src|送信元IPアドレスを指定する(ファイル指定可能)|
|dst|送信先IPアドレスを指定する(ファイル指定可能)|
|dstdomain|送信先ドメインを指定する(ファイル指定可能)|
|dstdom_regex|正規表現を使用し送信先ドメインを指定する(ファイル指定可能)|
|port||
|method||
|req_mime_type||
|rep_mime_type||
|snmp_community||
|any-of|ホワイトリストを束ねたりするときに使う|
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
cache (allow|deny) acl
```
### ■ 使用例
```
### キャッシュ機能を無効化する
cache deny all
```
## ● cache_dir (cache)
(オンディスク)キャッシュとして使用するディスク量(とディレクトリ)を指定する。
### ■ Syntax
```
cache_dir StorageType Directory SIZE L1 L2 [option]
```
#### StorageType
ストレージ書き込みの方式の種類(ufs,aufs,disked)を指定する
#### Directory
キャッシュを保存するディレクトリを指定する
#### SIZE
ディスクキャッシュの大きさをMB単位で指定する
#### L1・L2
squidではキャッシュを2階層の階層構造を持つディレクトリに保存している。  
L1には1階層目のディレクトリ数を指定し、L2には2階層目のディレクトリ数を指定する
#### option
- min-size

キャッシュするオブジェクトの最小のサイズをバイト単位で指定する  
※ キャッシュディレクトリが複数ある場合に有効
- max-size

キャッシュするオブジェクトの最大のサイズをバイト単位で指定する  
※ キャッシュディレクトリが複数ある場合に有効
### ■ 使用例
```
cache_dir ufs /var/spool/squid 100 16 256
```
以下のコマンドでキャッシュディレクトリを作成する。
```
# squid -z
```
## ● cache_log (common)
squidのログの出力先を指定する
### ■ Syntax
```
cache_log file
```
### ■ 使用例
```
cache_log /var/log/squid/cache.log
```
## ● cache_mem (cache)
(インメモリ)キャッシュとして使用するメモリ量(デフォルトは256MB)を指定する。
### ■ Syntax
```
cache_mem SIZE
```
### ■ 使用例
```
cache_mem 1500MB
```
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
squidのコアファイルの出力先ディレクトリを指定する
### ■ Syntax
```
coredump_dir Directory
```
### ■ 設定例
```
coredump_dir /var/spool/squid
```
## ● dns_defnames
名前解決にsearch/domainを使用できる
## ● dns_nameservers
### ■ Syntax
```
dns_nameservers nameserver...
```
resolv.confで定義されたDNSサーバ以外を参照したいという場合に使用する。  
dns_nameserversで指定したDNSサーバを優先して利用する。

### ■ 設定例
```
dns_nameservers 8.8.8.8 8.8.4.4
```

## ● dns_v4_first (common)
### ■ Syntax
```
dns_v4_first (on|off)
```
アクセス先がIPv4/IPv6デュアルスタックの場合に、どちらのプロトコルを優先するかを指定する。

### ■ 使用例
```
dns_v4_first on
```

## ● follow_x_forwarded_for
XFF(X-Forwarded-For)ヘッダから、リクエストの送信ホストを調べます。  
XFFヘッダに複数のアドレスが含まれている場合、リストの最初のアドレスを送信ホストとして利用します。  
※ 例えば、ロードバランサがXFFに送信元IPアドレスを加える場合、XFFのリストの先頭に追加される(ことを利用する)  
※ ソースIPを維持しないロードバランサの場合に有効なオプション(かも)
### ■ Syntax
```
follow_x_forwarded_for (allow|deny) acl
```
### ■ 使用例
```
### ロードバランサのACLを追加
acl LoadBalancer src 192.168.137.25/32
follow_x_forwarded_for allow LoadBalancer
```
## ● forwarded_for (security)
### ■ 使用例
```
forwarded_for off
```
## ● fqdncache_size
squidが名前解決(逆引きに限る)した結果をメモリキャッシュ上に保存するFQDNの最大数を指定する。
### ■ Syntax
```
fqdncache_size SIZE
```
### ■ 使用例
```
fqdncache_size 10000
```
## ● hosts_file
### ■ Syntax
```
hosts_file "file"
```
fileにホスト名とIPアドレスの関連付いたファイルを指定する。

### ■ 設定例
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
### ■ Syntax
```
httpd_suppress_version_string (on|off)
```
HTTPヘッダとHTMLエラーページに表示されるSquidのバージョン情報を抑制する。

### ■ 使用例
```
httpd_suppress_version_string on
```

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
### ■ Syntax
```
ipcache_high PERCENTAGE
```
### ■ 使用例
```
ipcache_high 95
```
## ● ipcache_low (cache)
同上
### ■ Syntax
```
ipcache_low PERCENTAGE
```
### ■ 使用例
```
ipcache_low 90
```
## ● ipcache_size (cache)
squidが名前解決(正引きに限る)した結果をメモリキャッシュ上に保存するIPアドレスの最大数を指定する。
### ■ Syntax
```
ipcache_size SIZE
```
### ■ 使用例
```
ipcache_size 15000
```
## ● logfile_rotate
ログの世代数(間隔はdaily)を設定する。  
ここで設定したならば`squid -k rotate`コマンドを実行しないといけない。  
※ logrotatedでいいと思う
## ● logformat (log)
## ● max_filedescriptors
## ● maximum_object_size (cache)
ディスク上にキャッシュされるオブジェクトの最大サイズをバイト単位で指定する。
### ■ Syntax
```
maximum_object_size SIZE
```
### ■ 使用例
```
maximum_object_size 100MB
```
## ● maximum_object_size_in_memory (cache)
メモリ上にキャッシュされるオブジェクトの最大サイズをバイト単位で指定する。
### ■ Syntax
```
maximum_object_size_in_memory SIZE
```
### ■ 使用例
```
maximum_object_size_in_memory 8MB
```
## ● memory_cache_mode (cache)
メモリにキャッシュするオブジェクトを制御します。
- always
最近取得したオブジェクトをメモリにキャッシュします。

- disk
ディスクのキャッシュで(少なくとも一度)ヒットしたオブジェクトをメモリにキャッシュします。

- network
ネットワーク経由で取得したオブジェクトのみメモリにキャッシュします。
## ● minimum_object_size (cache)
ディスク上にキャッシュされるオブジェクトの最小サイズをバイト単位で指定する。
### ■ Syntax
```
minimum_object_size SIZE
```
### ■ 使用例
```
minimum_object_size 0KB
```
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
### ■ 使用例
要件に応じて許可・拒否を設定します。
```
request_header_access Referer deny all
request_header_access User-Agent deny all
request_header_access X-Forwarded-For deny all
request_header_access Via deny all
request_header_access Cache-Control deny all
```
## ● server_persistent_connections
## ● snmp_access (monitoring)
SNMPポートへのアクセスを許可または拒否を指定する
### ■ Syntax
```
snmp_access (allow|deny) aclname...
```
### ■ 使用例
```
acl community snmp_community public
snmp_access allow community localhost
snmp_access deny all
```
## ● snmp_port (monitoring)
squidがSNMP要求をリッスンするポート番号を指定する
### ■ Syntax
```
snmp_port PORT
```
### ■ 使用例
```
snmp_port 3401
```
## ● strip_query_terms (log)
urlからクエリ用語が一部抜ける
## ● tcp_outgoing_address
ソースアドレス(や認証ならユーザ名)をルールに、クライアントから受けたリクエストを送信するIPアドレスを振り分けることができる。  
例えば、ポート番号AへのアクセスならIPアドレスA、ポート番号BのアクセスならIPアドレスBといったことが可能となる。  
### ■ Syntax
```
tcp_outgoing_address ipaddr [aclname]
```
### ■ 使用例
#### ポートごとにリクエストを振り分ける方法
```
acl ipv4 localport 8081
acl ipv6 localport 8082
tcp_outgoing_address 192.168.137.1 ipv4
tcp_outgoing_address 192.168.138.1 ipv6
```
## ● visible_hostname (security)
### ■ Syntax
```
visible_hostname hostname
```
単体プロキシサーバの動く環境では、hostnameにunknownと設定してホスト名を隠蔽する。  
複数プロキシサーバの動く環境では、hostnameにどのプロキシサーバであるか識別できる文字列を設定する。  

### ■ 使用例
```
### ホスト名の非表示
visible_hostname unknown
```
