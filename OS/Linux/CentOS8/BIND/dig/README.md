# dig
## ■ 便利なオプション
|オプション|説明|
|:---|:---|
|-t|クエリのタイプを指定する|
|-x|逆引きをする|
|+short|回答を簡略表示する|
|+identify|回答を返したDNSサーバを出力する|
|+trace|再起問い合わせの様子を追える|
|+norecurse|再起問い合わせをさせない(問い合わせ先が権威DNSサーバのときに有効)|
|+nssearch|ドメインの権威DNSサーバを探す|
|@|参照先のDNSサーバを指定する|

## ■ おぼえておくべきフラグ
|フラグ|説明|
|:---|:---|:---|
|qr|クエリかレスポンスか|
|rd|Recursion Desired|
|ra|Recursion Available|

## ■ Tips
### バージョン確認
```
# dig [@DNSサーバ] chaos version.bind -t txt
```

### ホスト名確認
```
# dig [@DNSサーバ] chaos hostname.bind -t txt
```
