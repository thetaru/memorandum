# ホワイトリスト
# (正規表現なし)ドメインによるフィルタリング
aclディレクティブを使ってwhitelistを定義します。
```
acl example_whitelist dstdomain "/etc/squid/whitelist"
```
`/etc/squid/whitelist`
```
yahoo.co.jp
.google.com
```
行頭にドット`.`がつくとサブドメインを含みます。  
`.example.com`と`hoge.example.com`が同一ホワイトリストに存在すると重複エラーが生じます。

## (正規表現あり)ドメインによるフィルタリング
aclディレクティブを使ってwhitelistを定義します。
```
acl example_whitelist dstdom_regex "/etc/squid/whitelist"
```
`/etc/squid/whitelist`
```
yahoo¥.co¥.jp
.*¥.google¥.com
```
正規表現でドメインを表します。  
サブドメインまで含めたい場合は行頭に`.*`をつけます。
