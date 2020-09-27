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
### ServerAdmin
連絡先用メールアドレスの設定  
エラーページを表示する際に、問い合わせ先となるメールアドレスを設定する  
大体、いつも設定しないのでコメントアウト。デフォルトは有効になっている
```
-  ServerAdmin root@localhost
+  ServerAdmin root@localhost
```
## ■ phpの設定
## ■ MariaDBの設定
