# 名前解決の挙動変更
## dns_defnames
FQDNで指定せずにアクセスする場合は注意が必要です。  
  
通常のプロキシサーバではドメインの探索は無効です。  
※ resolv.confのsearch、domainが効かない  
以下の設定を入れることで、resolv.confのsearch、domainが効くようになります。
```
dns_defnames on
```

## dns_v4_first
IPv4/IPv6デュアルスタックサーバに対してIPv4でアクセスするようにできます。  
デフォルトでは無効のため有効にするには以下のようにします。
```
dns_ipv4_first on
```
