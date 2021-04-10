# ベストプラクティス
## 設定に柔軟性をもたせる
カスタマイズしやすいようにするべきだと考えています。
```
# vi /etc/squid/squid.conf
```
```
+  include /etc/squid/conf.d/*.conf
```
として、`/etc/squid.d/`配下の設定ファイル(`.conf`)を読み込むようにしています。  
  
作るべきファイルは次くらいかなと思います。
- security.conf
- cache.conf
- log.conf
