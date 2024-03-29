# Postfix パラメータ一覧
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
※ ただし、日本語を扱う場合は文字コード(UTF-8など)ごとにMIMEにエンコードする必要があります

## ● inet_interfaces (★)
Postfixサービスがメールを受け取るネットワークインターフェースアドレスを指定します。
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
ホストから送られてきたメールを転送せずにローカルに配送するドメインを指定します。
### ■ 設定例
```
mydestination = $myhostname, localhost.$mydomain, localhost
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
中継可否はmynetworksとrelay_domains(ただし、優先順位はmynetworks > relay_domains)で制御し、転送先はtransport_mapに従います。
### ■ 設定例
```
mynetworks = 128.0.0.1/32,192.168.137.0/24,192.168.138.0/24
```

## ● relay_domains (★)
サーバがリレーする配送先のドメイン(適用範囲はサブドメインを含む)を指定します。  
mynetworksで指定したIPアドレス範囲に含まれる送信元IPアドレスの場合、relay_domainsで指定したドメインと関係なく中継されます。  
中継可否はmynetworksとrelay_domains(ただし、優先順位はmynetworks > relay_domains)で制御し、転送先はtransport_mapに従います。  
※ mynetworksで指定したIPアドレス範囲に含まれない場合、relay_domainsの設定が適用される
### ■ 設定例
```
relay_domains = example.com,example.jp
```

## ● relay_recipient_maps
relay_domainsにマッチするドメインを持つメールアドレスのリストファイルを指定します。  
リストファイルに記載したメールアドレスのみ中継されるようになるため、relay_domainsの制限(実質、送信元メールアドレスの制限)となります。
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

#### relay_recipients.db
postmapコマンドでrelay_recipientsファイルをhash化したDB(relay_recipients.db)を作成します。
```
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
biffの有効化・無効化を設定します。
### ■ 設定例
```
### biffの無効化
biff = no
```

## ● body_checks
### ■ 設定例
```
```

## ● body_checks_size_limit
body_checksでフィルタリング対象となるメッセージサイズを指定します。
### ■ 設定例
```
body_checks_size_limit = 51200
```

## ● bounce_queue_lifetime
送信失敗してから、配達不能と判定後、バウンスメール(エラーメール)を返すまでの時間を指定します。
### ■ 設定例
```
bounce_queue_lifetime = 5d
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
vrfyコマンドの有効・無効を設定します。
### ■ 設定例
```
### vrfyの無効化
disable_vrfy_command=yes
```

## ● maximal_queue_lifetime
送信失敗してから、配達不能と判定するまでの時間を指定します。  
この間、再送を試み続けます。
### ■ 設定例
```
maximal_queue_lifetime = 5d
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

## ● smtp_tls_note_starttls_offer
### ■ 設定例
```
smtp_tls_note_starttls_offer = yes
```

## ● smtp_tls_protocols
### ■ 設定例
```
```

## ● smtpd_etrn_restrictions
`ETRN`コマンドの制御
### ■ 設定例
```
smtpd_etrn_restrictions = permit_mynetworks,
                          reject
```

## ● smtpd_client_restrictions
Postfixサーバへの接続するホストの許可/拒否を設定します。
### ■ 設定例
```
smtpd_client_restrictions = permit_mynetworks,                                          # $mynetworksのホストからの接続を許可
                            check_client_access hash:/etc/postfix/reject_access_sender, #
                            reject_invalid_hostname,                                    #
                            permit                                                      #
```

## ● smtpd_helo_restrictions
`HELO`コマンドでホスト名を通知しないホストの接続の許可/拒否を設定します。
### ■ 設定例
```
smtpd_helo_restrictions = permit_mynetworks,            # $mynetworksのホストからの接続を許可
                          reject_invalid_helo_hostname, #
                          reject_non_fqdn_helo_hostname #
```

## ● smtpd_helo_require
### ■ 設定例
```
### ホスト名を通知しないホストの接続を拒否する
smtpd_helo_required = yes
```

## ● smtpd_recipient_restrictions
spam遮断ポリシーを設定します。  
`RCPT TO`コマンドで通知される宛先メールアドレスに応じてメール受信の許可/拒否を設定します。
### ■ 設定例
```
smtpd_recipient_restrictions = permit_mynetworks,                                          # $mynetworksのホストからの接続を許可
                               regexp:/etc/postfix/recipient_checks.reg,                   #
                               check_client_access hash:/etc/postfix/reject_access_sender, #
                               check_relay_domains                                         # 
```

## ● smtpd_relay_restrictions
リレーポリシーを設定します。
### ■ 設定例
```
smtpd_relay_restrictions = permit_mynetworks,         # $mynetworksのホストからの接続を許可
                           permit_sasl_authenticated, # SASL認証による認証を通れば許可
                           defer_unauth_destination   # サブネットかメールサーバ上のアドレス以外不許可
```

## ● smtpd_sender_restrictions
`MAIL FROM`コマンドで通知される送信元メールアドレスに応じてメール受信の許可/拒否を設定します。
### ■ 設定例
```
smtpd_sender_restrictions = check_sender_access hash:/etc/postfix/reject_access_sender # 
                            reject_non_fqdn_sender,                                    # 送信元メールアドレスがFQDN形式でない場合に拒否
                            reject_unknown_sender_domain                               # 送信元メールアドレスのドメインが存在しない(MX,Aレコードを引けない)場合に拒否
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
中継可否はmynetworksとrelay_domains(ただし、優先順位はmynetworks > relay_domains)で制御し、転送先はtransport_mapに従います。
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

#### transport.db
postmapコマンドでtransportファイルをhash化したDB(transport.db)を作成します。
```
# postmap /etc/postfix/transport
```
