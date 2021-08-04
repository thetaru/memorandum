# Record
## SOAレコード
### ■ 解説
SOA(Start of Authority)レコードは、ゾーン全体に影響するパラメータを定義するレコードです。

### ■ Syntax
```
@ IN SOA MNAME RNAME (
  SERIAL
  REFRESH
  RETRY
  EXPIRE
  MINIMUM
)
```
- @
> @は、直近の$ORIGINディレクティブで定義されたゾーン名を意味します。  
> @以前に$ORIGINディレクティブが宣言されていない場合、named.confで指定したゾーンのゾーン名となります。

- MNAME
> このゾーンのプライマリーDNSサーバのホスト名をFQDNで指定します。  
> ここに設定するホスト名は、AレコードでIPアドレスを定義したものでなければなりません。

- RNAME
> このゾーンの責任者のメールアドレスをFQDNで設定します。
> ※ 書き方に注意しましょう。

- SERIAL
> ゾーン情報のシリアル番号を指定します。  
> 一般的に、YYYYMMDD + 連番2桁で管理します。

- REFRESH
> スレーブサーバがマスターサーバに対してゾーン情報の更新の有無をチェックする周期を秒単位で示す数値です。  
> ※ SERIALの情報をが増加していた場合、ゾーン情報の更新が始まります。

- RETRY
> マスターサーバやネットワークの障害によりポーリングが失敗した際に、再試行の周期を秒単位で示す数値です。

- EXPIRE
> マスターサーバがダウンした場合、スレーブサーバはこの数値で提示された期間が経過するまでは、最後にマスターサーバから受け取ったゾーン情報を有効なものとしてサービスを継続しますが、期間満了とともにそのゾーン情報を無効として廃棄します。

- MINIMUM
> 各リソースレコードのデフォルトのTTL(Time To Live=有効期間)を秒数で指定します。

### ■ 設定例
```
@ IN SOA ns.example.com. root.example.com. (
  2021073001 ; Serial
  10800 ; Refresh
  600 ; Retry
  86400 ; Expire
  3600 ; Negative TTL
)
```

## NSレコード
### ■ 解説
NS(Name Server)レコードは、ドメインのゾーン情報が登録されているDNSサーバを定義するレコードです。  
管理の委託先を指定する際にNSレコードを追加します。  
特に、NSレコードで自DNSサーバのドメイン名を指定する場合、そのドメインは自分で管理することを意味します。  
また、登録するDNSサーバのホスト名は、Aレコードが登録されているホスト名のみ設定できます。

### ■ Syntax
```
OWNER [TTL] IN NS NSDNAME
```
- OWNER
> ドメイン名を指定します。

- NSDNAME
> ドメインの権威DNSサーバ名を指定します。

### ■ 設定例
```
examle.com. IN NS ns.example.com
```

## Aレコード
### ■ 解説
Aレコードは、ホスト名とIPアドレスの関連付けを定義するレコードです。

### ■ Syntax
```
OWNER [TTL] IN A ADDRESS
```
- OWNER
> ドメイン名を指定します。

- ADDRESS
> IPv4のIPアドレスを指定します。

### ■ 設定例
```
www.example.com. 86400 IN A 192.168.137.1
```

## AAAAレコード
### ■ 解説
AAAAレコードは、ホスト名とIPv6アドレスの関連付けを定義するレコードです。

### ■ Syntax
```
OWNER [TTL] IN AAAA ADDRESS
```
- OWNER
> ドメイン名を指定します。

- ADDRESS
> IPv6のIPアドレスを指定します。

### ■ 設定例
```
www.example.com. 86400 IN AAAA 2001:db8:dead:beef::1
```

## MXレコード
### ■ 解説
MX(Mail eXchanger)レコードは、メールのリレー先となるホスト名を定義するレコードです。

### ■ 設定例
```
example.com. IN MX 10 smtp.example.com.
```

## CNAMEレコード
### ■ 解説
CNAME(Canonical NAME)レコードは、正規のホスト名とホストの別名との関連付けを定義するレコードです。  

### ■ Syntax
```
OWNER [TTL] IN CNAME CNAME
```
- OWNER
> 正式名に対する別名を指定します。
- CNAME
> 別名に対する正式名を指定します。

### ■ 設定例
```
foo.example.com. IN A     192.168.137.1
www.example.com. IN CNAME foo.example.com.
```

## SRVレコード
### ■ 解説
SRV(SeRVice)レコードは、ドメイン名に対するサービスのロケーションを定義するレコードです。

### ■ 設定例
```
```

## TXTレコード
### ■ 解説
TXT(TeXT)レコードは、ホストに関連付けるテキスト情報(文字列)を定義するレコードです。

### ■ 設定例
```
```

## DSレコード
### ■ 解説
DS(Delegation Signer)レコードは、サブドメインでDNSSECを利用するためのレコードです。

### ■ 設定例
```
```

## PTRレコード
### ■ 解説
PTR(PoinTR)レコードは、IPアドレスとホスト名の関連付けを定義するレコードです。  
1つのIPアドレスに対して、1つのホスト名を登録できます。

### ■ Syntax
```
OWNER [TTL] IN PTR PTRDNAME
```
- OWNER
> in-addr.arpa.やip6.arpa.の名前空間でのIPアドレスを指定します。

- PTRDNAME
> IPアドレスに対するドメイン名を指定します。

### ■ 設定例
```
1 IN PTR www.example.com.
```
