# log.confのテンプレート
```
cache_log /var/log/squid/cache_log

logformat combined %>a %ui %un [%tl] "%rm %ru HTTP/%rv" >Hs %h" "%{User-Agent}>h" %Ss:%Sh
access_log /var/log/squid/access.log combined
```
