# zabbixのPHPエラー
## 「監視データ」-「概要」を読み込めない
エラーを調査してみたところ
```
# tail -f /var/log/httpd/error.log
```
```
Fatal error: Allowed memory size of xxxxxx bytes exhausted (tried to allocate 64 bytes)...
```
原因はPHPのメモリ不足です。  
メモリを割り当てられるように設定します。  
※ php.iniの設定に関しては不要かもです。
```
# vi /etc/php.ini
```
```
-  memory_limit 128M
+  memory_limit 512M
```
```
# vi /etc/httpd/conf.d/zabbix.conf
```
```
### 環境によって適切なメモリ設定をしてください
-  php_value memory_limit 128M
+  php_value memory_limit 512M
```
