# 名前解決の挙動変更
## dns_defnames
FQDNで指定せずにアクセスする場合は注意が必要です。  
通常のプロキシサーバではドメインの探索は無効です。(resolv.confのsearch、domainが効かない)  
以下の設定を入れることで、resolv.confのsearch、domainが効くようになります。
```
dns_defnames on
```
