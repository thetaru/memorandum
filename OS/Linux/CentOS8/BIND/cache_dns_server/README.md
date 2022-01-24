# キャッシュDNSサーバ
## ■ 前提条件
### ● 動作環境
|項目|ホスト名|IPアドレス|
|:---|:---|:---|
|キャッシュDNSサーバ|dns-03(.exmaple.com)|192.168.138.22|

### ● 設定方針
- optionsステートメントでは、例外を除き無効にするよう設定し、各viewやzoneで個別に設定する。\*1)
- ゾーンファイルの命名規則: `<domain>.zone`

\*1) optionsステートメントに同じoptionの記述があった場合、view-optionまたはzone-optionが優先されます。

## ■ インストール
```
# yum install bind bind-chroot bind-utils
```
  
## ■ バージョンの確認
```
# named -v
```
  
## ■ サービスの起動
```
# systemctl enable --now named-chroot.service
```
  
## ■ 事前設定
### ● rndc用の共有鍵の生成
```
# rndc-confgen -a -A hmac-sha512 -b 512 -u named
```
  
### ● ログファイルの作成
```
# mkdir -p /var/named/chroot/var/log/named
# touch /var/named/chroot/var/log/named/{default,query,security}.log
# chown -R named:named /var/named/chroot/var/log/named
```
  
### ● ゾーンファイルの作成
```
# touch /var/named/example.com.zone
# touch /var/named/named.zones
# chown root:named /var/named/example.com.zone
# chown root:named /var/named/named.zones
```

## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|named-chroot.service|53/tcp,udp||

## ■ 主設定ファイル /etc/named.conf
### ● 設定項目
[こちら]()にまとめました。

### ● 設定例
#### /etc/named.conf
```
acl internalnet {
  127.0.0.1;
  192.168.137.0/24;
  192.168.138.0/24;
};

include "/etc/rndc.key";
controls {
  inet 127.0.0.1 port 953 allow { 127.0.0.1; } keys { "rndc-key"; };
};

options {
  version "";
  hostname "";
  listen-on port 53 {
    127.0.0.1;
    192.168.138.22;
  };
  listen-on-v6 port 53 { none; };
  notify no;
  directory       "/var/named";
  dump-file       "/var/named/data/cache_dump.db";
  statistics-file "/var/named/data/named_stats.txt";
  memstatistics-file "/var/named/data/named_mem_stats.txt";
  secroots-file   "/var/named/data/named.secroots";
  recursing-file  "/var/named/data/named.recursing";
  
  allow-query       { internalnet; };
  allow-query-cache { internalnet; };
  
  allow-transfer { none; };
  allow-update { none; };
  
  recursion yes;
  allow-recursion { internalnet; };
  
  max-ncache-ttl 300;
  max-cache-ttl 3600;
  recursive-clients 2000;
  cleaning-interval 3600;
  max-cache-size 200M;
  
  empty-zones-enable yes;
  
  dnssec-enable yes;
  dnssec-validation yes;
  
  managed-keys-directory "/var/named/dynamic";

  pid-file "/run/named/named.pid";
  session-keyfile "/run/named/session.key";

  include "/etc/crypto-policies/back-ends/bind.config";
};

logging {
  channel default_debug {
    file "/var/log/named/default.log" versions 5 size 50M;
    severity dynamic;
    print-time yes;
    print-severity yes;
    print-category yes;
  };
  channel queries_log {
    file "/var/log/named/query.log" versions 5 size 50M;
    severity info;
    print-time yes;
    print-severity yes;
    print-category yes;
  };
  channel security_log {
    file "/var/log/named/security.log" versions 5 size 50M;
    severity info;
    print-time yes;
    print-severity yes;
    print-category yes;
  };
  
  category lame-servers { null; };
  category default { default_debug; };
  category queries { queries_log; };
  category security { security_log; };
};

include "/var/named/named.zones";
include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```
#### /var/named/named.zones
DNSSEC未対応のDNSにforwardする場合、名前解決ができないため、named.confの`dnssec-validation`を`no`に設定する必要があります。
```
zone "." IN {
  type hint;
  file "named.ca";
};

/*
zone "example.com" {
  type forward;
  forward only;
  forwarders { 192.168.138.21; 192.168.138.22; };
  allow-query { internalnet; };
};

zone "138.168.192.in-addr.arpa" {
  type forward;
  forward only;
  forwarders { 192.168.138.21; 192.168.138.22; };
  allow-query { internalnet; };
};
 */
```

### ● 文法チェック
```
# named-checkconf /etc/named.conf
```

## ■ チューニング
## ■ 設定の反映
```
# systemctl restart named-chroot.service
```
## ■ 設定の確認
### ● ローカルネットワーク側から名前解決が行えること
nslookupやdig等の名前解決コマンドでローカルネットワーク側から名前解決できることを確認します。
### ● インターネット側から名前解決が行えること
nslookupやdig等の名前解決コマンドでインターネット側から名前解決できることを確認します。
### ● オープンリゾルバとなっていないこと
[オープンリゾルバ確認サイト](http://www.openresolver.jp/)があるので、そちらから確認できます。
### ● ホスト名が表示されないこと
サーバ側・クライアント側からホスト名が表示されないことを確認します。
```
# dig @192.168.138.20 chaos hostname.bind -t txt
```
### ● バージョンが表示されないこと
サーバ側・クライアント側からバージョンが表示されないことを確認します。
```
# dig @192.168.138.20 chaos version.bind -t txt
```
### ● 再帰問い合わせを行えること
```
 # dig @192.168.138.20 +trace example.com
```

### ● キャッシュを行えること
キャッシュデータをファイルにダンプし、キャッシュデータが存在することを確認します。  
また、bindの統計情報を取得しキャッシュのヒット率等を確認します。
```
### キャッシュデータをダンプ
# rndc dumpdb -cache
# less /var/named/data/cache_dump.db

### 統計情報を取得
# rndc stats
# less /var/named/data/named_stats.txt
```

### ● ログローテーションが行われていること
設定によって、ログサイズでローテーションを行う場合とlogrotatedでローテーションを行う場合があるため注意します。

### ● インターネットからのクエリに対してプライベートアドレスを返さないこと
`/var/log/messages`を確認しプライベートアドレスが漏れていないことを確認します。  
```
# grep "RFC 1918" /var/log/messages
```

### ● ソースポートランダマイゼーションが行われていること

### ● トランザクションIDのランダム化が行われていること

## ■ 負荷テスト項目
- XXXrpsのクエリ処理に耐えられること
- クライアントN台からの同時接続に耐えられること

## ■ 監視項目
- ポート監視
  - 単位: -
  - 説明: 53/tcpでListen
