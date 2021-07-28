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
|Cc:|To:で指定した宛先に送信されるメールと同じ内容のものを、Cc:で指定した宛先にも送信する|
|Bcc:||
|Subject:|件名を示す|
|Date:|メッセージ送信を開始した時間を表す|

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

## ● inet_interfaces (★)
### ■ 設定例
```
```

## ● inet_protocols (★)
### ■ 設定例
```
```

## ● local_recipient_maps
### ■ 設定例
```
```

## ● mydestination (★)
### ■ 設定例
```
```

## ● mydomain (★)
### ■ 設定例
```
```

## ● myhostname (★)
### ■ 設定例
```
```

## ● myorigin (★)
### ■ 設定例
```
```

## ● mynetworks (★)
### ■ 設定例
```
```

## ● relay_domains (★)
### ■ 設定例
```
```

## ● relay_recipient_maps
### ■ 設定例
```
```

## ● relayhost (★)
### ■ 設定例
```
```

## ● smtp_tls_security_level
### ■ 設定例
```
```

## ● smtp_use_tls
### ■ 設定例
```
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

## ● canonical_classes
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

## ● sender_canonical
### ■ 設定例
```
```

## ● smtpd_client_restrictions
### ■ 設定例
```
```

## ● smtpd_recipient_restrictions
### ■ 設定例
```
```

## ● smtpd_sender_restrictions
### ■ 設定例
```
```

## ● smtpd_use_tls
### ■ 設定例
```
```
