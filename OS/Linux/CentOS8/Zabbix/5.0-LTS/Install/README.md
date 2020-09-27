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
### DirectoryIndex
ディレクトリにファイル指定無しのアクセスがあった場合に、どのファイルを表示するかを設定する。  
デフォルトはindex.htmlのみ。PHPなどを使用する場合はindex.phpも指定する。
```
<IfModule dir_module>
-    DirectoryIndex index.html
+    DirectoryIndex index.html index.php
</IfModule>
```
### mime
```
<IfModule mime_module>
    ...
    AddType application/x-compress .Z
    AddType application/x-gzip .gz .tgz
+   AddType application/x-httpd-php .php
    ...
</IfModule>
```
### Directory
#### FollowSymLinks
Apacheでファイル一覧を表示させないようにする
```
<Directory "/var/www/html">
-   Options Indexes FollowSymLinks
+   Options -Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
```
### バージョン隠し
レスポンスヘッダーのバージョンを非表示にする
```
+  ServerTokens ProductOnly
```
エラーページのフッターにバージョンを非表示にする
```
+  ServerSignature Off
```
### CGI
```
<IfModule alias_module>
-   ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
+   #ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>

-  <Directory "/var/www/cgi-bin">
-     AllowOverride None
-     Options None
-     Require all granted
-  </Directory>
+  #<Directory "/var/www/cgi-bin">
+  #    AllowOverride None
+  #    Options None
+  #    Require all granted
+  #</Directory>
```
## ■ phpの設定
## ■ MariaDBの設定
