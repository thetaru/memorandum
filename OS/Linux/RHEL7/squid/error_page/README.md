# エラーページの設定
|項目|設定|
|:---|:---|
|エラーページ格納先|/usr/share/squid/errors/Japanese|

```
# vi /etc/squid/squid.conf
```
```
+  error_directory /usr/share/squid/errors/Japanese
```

必要に応じてエラーページを編集し、ブラウザに表示させる文言等を変更してください。
