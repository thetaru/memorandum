# メール系
## ■ メールキューの確認
```
# postqueue -p
```

## ■ 滞留メールの全削除
```
# postsuper -d ALL
```

## ■ telnetでメール送信

|文法|説明|
|:---|:---|
|HELO クライアントドメイン名|クライアントをメールサーバに認識させる|
|MAIL FROM: 送信元メールアドレス|送信元をメールサーバに認識させる|
|RCPT TO: 送信先メールアドレス|送信先をメールサーバに認識させる|
|DATA|メールのデータを転送を開始する|
|QUIT|メールの送信を終了する|

```
# telnet mail-srv.example.com 25
```
```
Trying XXX.XXX.XXX.XXX...
Connected to XXX.XXX.XXX.XXX.
Escape character is '^]'.
220 mail-srv.example.com ESMTP Postfix
HELO example.com
250 mail-srv.example.com
MAIL FROM: user@example.com
250 2.1.0 Ok
RCPT TO: thetaru@test.com
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
From: user@example.com
Subjet: test
Hello world.
.
250 2.0.0 Ok: queued as XXXXXXXXXXX
```
