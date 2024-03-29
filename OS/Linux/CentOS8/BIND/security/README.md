# セキュリティ
## ■ ゾーン委任
## lame delegation
- ゾーンの委任元の委任設定が正しいこと

委任元の設定において、委任先となるDNSサーバの指定が誤っていた場合にlame delegationになります。  
※ 委任先の権威DNSサーバのグローバルアドレスが変更(e.g. 移行の際など)となった場合などに起こり得る
```
### インターネットから対象ドメインの権威DNSサーバを検索
# dig +nssearch example.com
SOA ns.icann.org. noc.dns.icann.org. 2021090202 7200 3600 1209600 3600 from server 199.43.135.53 in 110 ms.
SOA ns.icann.org. noc.dns.icann.org. 2021090202 7200 3600 1209600 3600 from server 199.43.133.53 in 110 ms.

### ドメインの委任元DNSサーバのNSレコードを確認
# dig +norec @199.43.133.53 example.com. ns
(snip)
;; ANSWER SECTION:
example.com.		86400	IN	NS	a.iana-servers.net.
example.com.		86400	IN	NS	b.iana-servers.net.
(snip)

### 正しいグローバルアドレスであることを確認
# dig +norec @199.43.133.53 a.iana-servers.net. a
(snip)
;; ANSWER SECTION:
a.iana-servers.net.	1800	IN	A	199.43.135.53
(snip)
```
- ゾーンの委任先の設定が正しいこと

```
### 委任されたゾーンについてのレコードが正しく設定されていることを確認
# less sub.example.com
(snip)
sub.example.com.     IN NS ns1.sub.example.com. <- (サブ)ドメインsub.example.com.は自身で回答する
(snip)
ns1.sub.example.com. IN A  192.0.2.80
(snip)
www.sub.example.com. IN A  192.0.2.81
(snip)
```
- ゾーン転送が行われていること

マスターとスレーブ間でゾーン転送が失敗している場合、スレーブに対して名前解決するクライアントは一部のレコードが引けない可能性があります。  
ここでは、マスター側とスレーブ側のゾーンファイルのシリアルを見ること(シリアルが同じであること)を確認します。
```
### マスターとスレーブで各ゾーンファイルのシリアルに差がないことを確認
# 
```
## ■ ゾーン更新
## シリアル

## ■ レコード
## A/AAAAレコード
- インターネットからの名前解決の際に、プライベートアドレスを返さないこと
```
### インターネットから対象ドメインの権威DNSサーバを検索
# dig +nssearch toyota.co.jp
SOA ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600 from server 210.175.128.35 in 13 ms.
SOA ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600 from server 210.175.152.115 in 13 ms.
SOA ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600 from server 210.175.152.116 in 13 ms.
SOA ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600 from server 210.175.129.70 in 13 ms.

### ドメインのSOAレコードを確認
# dig +norec @210.175.129.70 toyota.co.jp. soa
(snip)
;; ANSWER SECTION:
toyota.co.jp.		900	IN	SOA	ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600
(snip)

### プライマリDNSサーバの名前解決を実施
# dig +norec @210.175.129.70 ns1_auth.toyota.co.jp.
(snip)
;; ANSWER SECTION:
ns1_auth.toyota.co.jp.	900	IN	A	192.168.10.204 <- プライベートアドレスが見えている
(snip)
```

## SPFレコード
- SPFレコードの文法が正しいこと

TXTレコードのため、エラーとして出力されないことに注意します。  
SPFレコードの文法チェック用サイト(`https://vamsoft.com/support/tools/spf-syntax-validator`)があるので、利用しましょう。
- ドメインに対し、複数のSPFレコードを設定していないこと
```
### インターネットから対象ドメインの権威DNSサーバを検索
# dig +nssearch google.com
SOA ns1.google.com. dns-admin.google.com. 397037882 900 900 1800 60 from server 216.239.34.10 in 40 ms.
SOA ns1.google.com. dns-admin.google.com. 397037882 900 900 1800 60 from server 216.239.38.10 in 40 ms.
SOA ns1.google.com. dns-admin.google.com. 397037882 900 900 1800 60 from server 216.239.36.10 in 46 ms.
SOA ns1.google.com. dns-admin.google.com. 397037882 900 900 1800 60 from server 216.239.32.10 in 80 ms.

### ドメインのTXTレコードを確認
# dig +norec @216.239.32.10 google.com txt
(snip)
google.com.		3600	IN	TXT	"v=spf1 include:_spf.google.com ~all"
(snip)
```

## DMARCレコード
- レポート
```
### インターネットから対象ドメインの権威DNSサーバを検索
# dig +nssearch google.com
SOA ns1.google.com. dns-admin.google.com. 397037882 900 900 1800 60 from server 216.239.34.10 in 40 ms.
SOA ns1.google.com. dns-admin.google.com. 397037882 900 900 1800 60 from server 216.239.38.10 in 40 ms.
SOA ns1.google.com. dns-admin.google.com. 397037882 900 900 1800 60 from server 216.239.36.10 in 46 ms.
SOA ns1.google.com. dns-admin.google.com. 397037882 900 900 1800 60 from server 216.239.32.10 in 80 ms.

### ドメインのTXTレコードを確認
# dig +norec @216.239.32.10 _dmarc.google.com. txt
(snip)
;; ANSWER SECTION:
_dmarc.google.com.	300	IN	TXT	"v=DMARC1; p=reject; rua=mailto:mailauth-reports@google.com"
(snip)
```
