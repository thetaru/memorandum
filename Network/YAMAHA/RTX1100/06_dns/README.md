# DNS設定
## ■ 静的DNSレコードの登録
```
# dns static <type> <fqdn> <value> [ttl=<ttl>]
```
AレコードとPTRレコードの両方を設定する場合は以下のコマンドを実行する。
```
# ip host <fqdn> <value> [ttl=<ttl>]
```

## ■ Ref
- [27.11 静的 DNS レコードの登録](http://www.rtpro.yamaha.co.jp/RT/manual/rt-common/dns/ip_host.html)
