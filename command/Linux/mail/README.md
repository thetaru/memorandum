# メール系
## ■ メールキューの確認
```
# postqueue -p
```

## ■ 滞留メールの全削除
```
# postsuper -d ALL
```

## ■ smtpd_helo_restrictions
### reject_invalid_helo_hostname
```
# telet メールサーバ 25
```
```
### 私はこういうものですという挨拶(HELO)をする
> HELO 送信元ホスト名(FQDN)
< 250

> mail from:
< 250 2.1.0 Ok

> rcpt to: <>

```
