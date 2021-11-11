# Common
## ● header_checks
ヘッダ情報によるフィルタリング(OK|REJECT)やヘッダ情報の書き換え(REPLACE)を設定できます。
### ■ ヘッダフィールド
|ヘッダ|説明|
|:---|:---|
|Return-Path:|メール送信元へのリターンアドレスを示す</br>最後にメールを受け取ったSMTP/ESMTPサーバが付加する|
|Received:|メールが転送されてきた経路を示す|
|Reply-to:|返信先メールアドレスをFrom:以外に指定していることを示す|
|From:|メールの送信者のアドレスを示す|
|To:|メールの受信者を示す|
|Cc:|To:で指定した宛先に送信されるメールと同じ内容のものをCc:で指定した宛先にも送信する|
|Bcc:||
|Subject:|件名を示す|
|Date:|メッセージ送信を開始した時間を示す|

### ■ 設定例
#### /etc/postfix/main.cf
```
header_checks = regexp:/etc/postfix/header_checks
```

#### /etc/postfix/header_checks
ルールは上から適用されます。
```
/^To: hoge@example.com/ OK
/^To: .*@example.jp/ OK
/^To: .*/ REJECT

/^Subject: .*MOUKEBANASI.*/ REJECT
/^Subject: TEST(.*)/ REPLACE Subject: TEST $1

/^From: .*@gmail\.com/ REJECT

/^Received:\sfrom .*\[127\.0\.0\.1\]|^Received:\sfrom .*\[192\.168.*\]|^Received:\sfrom .*\[172\.16.*\]/ IGNORE
```

### ■ header_checks.dbの作成
postmapコマンドでheader_checksファイルをhash化したDBを作成します。
```
# cp -p /etc/postfix/header_checks{,.$(date +%Y%m%d)}
# postmap /etc/postfix/header_checks
```

## ● inet_interfaces (★)
Postfixサービスがメールを受け取るネットワークインターフェースアドレスを指定します。  
https://qiita.com/bezeklik/items/438eadbdb06672f3c3b6#inet_interfaces
### ■ 設定例
```
### すべてのインターフェースを利用
inet_interfaces = all

### 特定のインターフェースを利用
inet_interfaces = 192.168.138.15, 127.0.0.1

### インターフェースを利用しない(サーバ内部で閉じる)
inet_interfaces = localhost
```

## ● inet_protocols (★)
Postfixサービスが使用するインターネットプロトコルを指定します。  
### ■ 設定例
```
### IPv4のみ
inet_protocols = ipv4

### IPv6のみ
inet_protocols = ipv6

### IPv4/IPv6両対応(デフォルト)
inet_protocols = all
```

## ● local_recipient_maps
知らないローカルユーザを拒否する設定ができます。  
https://tksm.org/wp/archives/450  
http://www.ice.is.kit.ac.jp/~umehara/misc/comp/20091218c.html  


## ● mydestination (★)
### ■ 設定例
```
$myhostname, localhost.$mydomain, localhost
```

## ● mydomain (★)
サーバが所属するドメイン名を指定します。
### ■ 設定例
```
mydomain = example.com
```

## ● myhostname (★)
サーバのホスト名をFQDNで指定します。
### ■ 設定例
```
myhostname = mail-01.example.com
```

## ● myorigin
ローカルで送信されたメールがどのドメインから来るように見えるかを設定する。  
一般的に、$myhostname(デフォルト)か$mydomainを指定します。  
  
送信者のアドレスがユーザ名のみの場合、<ユーザ名>@<$myorigin>のように@以降に設定値が補完されます。  
※ 例えば、maillogに`From: root@localhost.localdomain`といった風に記載されます

### ■ 設定例
デフォルトでは$myhostname(ホスト名)で補完されてしまうので、$mydomain(ドメイン名)で補完されるようにします。
```
myorigin = $mydomain
```

## ● mynetworks (★)
外部ドメインへのメールをリレーを許可するクライアントを指定します。  
また、mynetworksの設定の優先度は高いためリレーを許可する場合は必要最小限に留めましょう。
### ■ 設定例
```
mynetworks = 128.0.0.1/32,192.168.137.0/24,192.168.138.0/24
```

## ● relay_domains (★)
サーバがリレーする配送先のドメイン(適用範囲はサブドメインを含む)を指定します。  
mynetworksで指定したIPアドレス範囲に含まれる送信元IPアドレスの場合、relay_domainsで指定したドメインと関係なく中継されます。  
※ mynetworksで指定したIPアドレス範囲に含まれない場合、relay_domainsの設定が適用される
### ■ 設定例
```
relay_domains = example.com,example.jp
```

## ● relay_recipient_maps
relay_domainsにマッチするドメインを持つメールアドレスのリストファイルを指定します。
### ■ 設定例
#### /etc/postfix/main.cf
```
relay_recipient_maps = hash:/etc/postfix/relay_recipients
```
#### /etc/postfix/relay_recipients
```
### 任意のexample.comをドメインに持つメールアドレス
@example.com

### 決め打ちされたメールアドレス
test1@example.jp
```

### ■ relay_recipients.dbの作成
postmapコマンドでrelay_recipientsファイルをhash化したDBを作成します。
```
# cp -p /etc/postfix/relay_recipients{,.$(date +%Y%m%d)}
# postmap /etc/postfix/relay_recipients
```

## ● relayhost (★)
リレー先のメールサーバを指定します。  
ただし、`transport_maps`でドメインごとにリレー先を振り分ける場合は`relayhost`は不要です。
### ■ 設定例
```
relayhost = [smtp-relay.example.com]
```
※ [ ]有りはAレコードで解決し、[ ]無しはMXレコードで解決することに注意

## ● smtp_tls_security_level
SMTPクライアントが使用するTLSセキュリティレベルを指定します。
### ■ 設定例
```
smtp_tls_security_level = may
```

## ● smtpd_banner (★)
### ■ 設定例
```
```

## ● smtpd_tls_cert_file
### ■ 設定例
```
```

## ● smtpd_tls_key_file
### ■ 設定例
```
```

## ● smtpd_tls_security_level
### ■ 設定例
```
```

# Option
## ● biff (★)
### ■ 設定例
```
```

## ● body_checks
### ■ 設定例
```
```

## ● body_checks_size_limit
### ■ 設定例
```
```

## ● bounce_queue_lifetime
### ■ 設定例
```
```

## ● canonical_classes
https://blog.jicoman.info/2014/09/postfix_aliases_envelope_from/
### ■ 設定例
```
```

## ● canonical_maps (★)
### ■ 設定例
```
```

## ● disable_vrfy_command
### ■ 設定例
```
```

## ● maximal_queue_lifetime
### ■ 設定例
```
```

## ● message_size_limit
メールサイズの上限をバイト単位で指定します。
### ■ 設定例
```
### 50MBで制限
message_size_limit= 52428800
```

## ● parent_domain_matches_subdomain
`relay_domains`に含まれるドメイン(e.g. example.com)のサブドメイン(e.g. .example.com)のリレーを許可します。  
`parent_domain_matches_subdomain`の設定値を空にすることで、明示的に`.domain.tld`形式を指定できます。
### ■ 設定例
```
### 空
relay_domains =
```

## ● sender_canonical_classes
### ■ 設定例
```
```

## ● sender_canonical_maps
### ■ 設定例
```
```

## ● smtp_tls_loglevel
### ■ 設定例
```
```

## ● smtp_tls_mandatory_ciphers
### ■ 設定例
```
```

## ● smtp_tls_mandatory_exclude_ciphers
### ■ 設定例
```
```

## ● smtp_tls_mandatory_protocols
### ■ 設定例
```
```

## ● smtp_tls_protocols
### ■ 設定例
```
```

## ● smtpd_client_restrictions
### ■ 設定例
```
```

## ● smtpd_helo_restrictions
### ■ 設定例
```
```

## ● smtpd_helo_required
### ■ 設定例
```
```

## ● smtpd_recipient_restrictions
### ■ 設定例
```
```

## ● smtpd_relay_restrictions
### ■ 設定例
```
```

## ● smtpd_sender_restrictions
https://qiita.com/tukiyo3/items/902b3c859346f6c00168
### ■ 設定例
```
```

## ● smtpd_tls_loglevel
### ■ 設定例
```
```

## ● smtpd_tls_mandatory_ciphers
### ■ 設定例
```
```

## ● smtpd_tls_mandatory_exclude_ciphers
### ■ 設定例
```
```

## ● smtpd_tls_mandatory_protocols
### ■ 設定例
```
```

## ● smtpd_tls_protocols
### ■ 設定例
```
```

## ● smtpd_use_tls
### ■ 設定例
```
```

## ● transport_maps
リレー先メールサーバのリストファイルを指定します。
### ■ 設定例
#### /etc/postfix/main.cf
```
transport_maps = hash:/etc/postfix/transport
```

#### /etc/postfix/transport
```
### example.jpドメイン宛のメールをrelay-smtp.example.jpへリレーする
example.jp     smtp:[relay-smtp.example.jp]

### example.comドメイン宛のメールはリレーしない
example.com        :

### example.comのサブドメイン宛のメールをrelay-smtp.example.comへリレーする
.example.com   smtp:[relay-smtp.example.com]

### 上記のルールに引っかからなかったドメイン宛のメールをrelay-smtp.example.co.jpへリレーする
*              smtp:[relay-smtp.example.co.jp]
```
※ [ ]有りはAレコードで解決し、[ ]無しはMXレコードで解決することに注意

### ■ transport.dbの作成
postmapコマンドでtransportファイルをhash化したDBを作成します。
```
# cp -p /etc/postfix/transport{,.$(date +%Y%m%d)}
# postmap /etc/postfix/transport
```
