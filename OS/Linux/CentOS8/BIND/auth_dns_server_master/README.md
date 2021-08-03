# 権威DNSサーバ(マスター)の構築
## ■ 前提条件
### ● 動作環境
|項目|IPアドレス|
|:---|:---|
|権威DNS(マスター)サーバ|192.168.138.20|
|権威DNS(スレーブ)サーバ|192.168.138.21|

### ● 設定方針
- optionsでは、基本的に無効にするよう設定し、各ゾーンで詳細に設定する。
※ optionsステートメントに同じoptionの記述があった場合、zone-optionが優先されます。  

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
# systemctl enable --now bind-chroot.service
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
  inet 127.0.0.1 port 953 allow { 127.0.0.1; } keys { "rndn-key"; };
};

options {
  version: "";
  hostname: "";
  listen-on port 53 {
    127.0.0.1;
    192.168.138.20;
  };
  listen-on-v6 port 53 { none; };
  directory       "/var/named";
  dump-file       "/var/named/data/cache_dump.db";
  statistics-file "/var/named/data/named_stats.txt";
  memstatistics-file "/var/named/data/named_mem_stats.txt";
  secroots-file   "/var/named/data/named.secroots";
  recursing-file  "/var/named/data/named.recursing";
  
  allow-query       { internalnet; localhost; };
  allow-query-cache { none; };
  
  allow-transfer { 192.168.138.21; };
  allow-update { none; };
  
  recursion no;
  allow-recursion { none; };
  
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
  channel query_log {
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
```

### ● 文法チェック
```
# named-checkconf /etc/named.conf

# named-checkzone <ドメイン> <(ドメインに対応する)ゾーンファイル>
```
## ■ 設定ファイル /etc/sysconfig/named
```
zone "." IN {
  type hint;
  file "named.ca";
};
```
## ■ セキュリティ
### ● firewall

## ■ ロギング
## ■ チューニング
## ■ 設定の反映
```
# systemctl restart named-chroot.service
```
## ■ 設定の確認
### ● ゾーン転送の確認
```
```

### ●
```
```
