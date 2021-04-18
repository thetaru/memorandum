# 時刻ズレで実行失敗
eksctlコマンドでクラスタ構築しようとしたらでてきました。
```
Error: checking AWS STS access – cannot get role ARN for current session: SignatureDoesNotMatch: Signature not yet current: 20210418T132743Z is still later than 20210418T054437Z (20210418T052937Z + 15 min.)
status code: 403, request id: 351f7e62-8389-40fb-8249-755846f9e08a
```
検索してみると時刻ズレが原因でした。
