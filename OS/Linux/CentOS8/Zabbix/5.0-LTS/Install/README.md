# ZabbixのInstall
## ■ SELinuxの無効化
```
# vi /etc/selinuc/config
```
```
-  SELINUX=enforcing
+  SELINUX=disabled
```
## ■ apacheの設定
```
# vi /etc/httpd/conf/httpd.conf
```
### Listen
Apacheのリッスンポートを指定する。
80番と443番をリッスンさせておく。Firewallやiptablesを使うならポートを空けること。
```
   Listen 80
+  Listen 443
```
### ServerAdmin
連絡先用メールアドレスの設定する。  
エラーページを表示する際に、問い合わせ先となるメールアドレスを設定する。  
いつも設定しないのでコメントアウト。デフォルトでは有効になっています。
```
-  ServerAdmin root@localhost
+  ServerAdmin root@localhost
```
### ServerName
Apacheサーバが自分自身のホスト名を示す時に使われる名前を指定する。  
デフォルトはコメントアウトですが、設定していないと構文チェックで警告が出ます。  
```
-  #ServerName www.example.com:80
+  ServerName <hostname>[:port]
```
### DocumentRoot
ルートディレクトリを指定する。  
Webコンテンツを置く場所。特に理由がなければデフォルトのままで設定する。
```
DocumentRoot "/var/www/html"
```
### Errorlog
エラーログの格納先をわかりやすいように「/var/log」配下に変更する。
```
-  ErrorLog "logs/error_log"
+  ErrorLog "/var/log"
```
### AccessLog
ログフォーマットの変更と格納先変更する。
```
-  CustomLog "logs/access_log" combined
+  CustomLog "/var/log/httpd/access_log" combined
```
## ■ phpの設定
## ■ MariaDBの設定
