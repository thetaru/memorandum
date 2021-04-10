# ベストプラクティス
## 設定に柔軟性をもたせる
カスタマイズしやすいようにするべきだと考えています。
```
# echo 'include /etc/squid/conf.d/*.conf' > /etc/squid/squid.conf
```
として、`/etc/squid.d/`配下の設定ファイル(`.conf`)を読み込むようにしています。
