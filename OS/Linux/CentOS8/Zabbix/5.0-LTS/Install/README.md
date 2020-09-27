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
大体、いつも設定しないのでコメントアウト。デフォルトでは有効になっている。
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
Webコンテンツを置く場所。特に理由がなければデフォルト(`/var/www/html`)のままで設定する。
```
DocumentRoot "/var/www/html"
```
## ■ phpの設定
## ■ MariaDBの設定
