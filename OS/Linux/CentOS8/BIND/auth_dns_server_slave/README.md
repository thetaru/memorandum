# 権威DNSサーバ(スレーブ)の構築
## ■ 前提条件
### ● 動作環境
|項目|ホスト名|IPアドレス|
|:---|:---|:---|
|権威DNS(マスター)サーバ|dns-01(.exmaple.com)|192.168.138.20|
|権威DNS(スレーブ)サーバ|dns-02(.example.com)|192.168.138.21|

### ● 設定方針
- optionsでは、基本的に無効にするよう設定し、各ゾーンで詳細に設定する。

※ optionsステートメントに同じoptionの記述があった場合、zone-optionが優先されます。
- ゾーンファイルの命名規則: <domain>.zone

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
### rndc用の共有鍵の生成
```
# rndc-confgen -a -A hmac-sha512 -b 512 -u named
```

### ログファイルの作成
```
# mkdir -p /var/named/chroot/var/log/named
# touch /var/named/chroot/var/log/named/{default,query,security}.log
# chown -R named:named /var/named/chroot/var/log/named
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
    192.168.138.20;
  };
  listen-on-v6 port 53 { none; };
  notify no;
  directory       "/var/named";
  dump-file       "/var/named/data/cache_dump.db";
  statistics-file "/var/named/data/named_stats.txt";
  memstatistics-file "/var/named/data/named_mem_stats.txt";
  secroots-file   "/var/named/data/named.secroots";
  recursing-file  "/var/named/data/named.recursing";
  
  allow-query       { none; };
  allow-query-cache { none; };
  
  allow-transfer { none; };
  allow-update { none; };
  
  recursion no;
  allow-recursion { none; };
  
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

include "named.zones";
include "/etc/named.rfc1912.zones";
include "/etc/named.root.key";
```

#### /var/named/named.zones
```
zone "example.com." IN {
  type slave;
  masters { 192.168.138.20; };
  file "slaves/example.com.zone";
  notify yes;
  allow-query { localhost; internalnet; };
  allow-transfer { none; };
  allow-update { none; };
};

zone "138.168.192.in-addr.arpa" {
  type slave;
  masters { 192.168.138.20; };
  file "slaves/138.168.192.rev";
  notify yes;
  allow-query { localhost; internalnet; };
  allow-transfer { none; };
};
```

### ● 文法チェック
```
# named-checkconf /etc/named.conf
```

## ■ チューニング
### ● ワーカー数

## ■ 設定の反映
```
# systemctl restart named-chroot.service
```

## ■ 設定の確認
### ● ゾーン転送の確認
```
# dig @192.168.138.20 example.com. axfr
```
