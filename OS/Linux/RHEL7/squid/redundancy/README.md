# プロキシの冗長構成について
## DNSラウンドロビンによる弊害
DNSに冗長化対象の複数プロキシのAレコードを次のように設定し、  
```
hoge.example.com. IN A 192.168.0.1
hoge.example.com. IN A 192.168.0.2
hoge.example.com. IN A 192.168.0.3
```
クライアントは代表となるFQDN(ここではhoge.example.com)でアクセスする方法です。
