# セキュリティ
## ■ レコード
## A/AAAAレコード
- インターネットからの名前解決の際に、プライベートアドレスを返さないこと
```
### インターネットから対象ドメインの権威DNSサーバを調べる
# dig toyota.co.jp +nssearch
SOA ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600 from server 210.175.128.35 in 13 ms.
SOA ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600 from server 210.175.152.115 in 13 ms.
SOA ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600 from server 210.175.152.116 in 13 ms.
SOA ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600 from server 210.175.129.70 in 13 ms.

### ドメインのSOAレコードを確認
# dig @210.175.129.70 toyota.co.jp. soa
...
;; ANSWER SECTION:
toyota.co.jp.		900	IN	SOA	ns1_auth.toyota.co.jp. postmaster.toyota.co.jp. 2020051899 900 3600 1209600 3600
...

### プライマリDNSサーバから名前解決を実施
# dig @210.175.129.70 ns1_auth.toyota.co.jp.
...
;; ANSWER SECTION:
ns1_auth.toyota.co.jp.	900	IN	A	192.168.10.204 <- プライベートアドレスが見えている
...
```

## SPFレコード
