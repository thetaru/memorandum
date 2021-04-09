# 名前解決の挙動変更
完全に定義されないホストネーム (例: http://mywebapp) を使って LAN 上のウェブサーバーにアクセスする場合、dns_defnames オプションを有効にする必要があります。このオプションが設定されていない場合、Squid はホストネームの DNS リクエストを作成してしまい (mywebapp)、LAN の DNS 設定によってはリクエストが失敗します。このオプションが有効になっていれば、Squid はリクエストを作成する際に /etc/resolv.conf に設定されているドメインを追加します (例: mywebapp.company.local)。

## dns_defnames
FQDNで指定せずにアクセスする場合は注意が必要です。  
通常のプロキシサーバではドメインの探索は無効です。(resolv.confのsearch、domainが効かない)  
以下の設定を入れることで、resolv.confのsearch、domainが効くようになります。
```
dns_defnames on
```
