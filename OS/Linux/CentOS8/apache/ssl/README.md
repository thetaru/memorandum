# HTTPS対応
## ■ SSL
```
# yum install mod_ssl
```
```
# mkdir -p /etc/httpd/ssl/private
# chmod 700 /etc/httpd/ssl/private
# openssl req -x509                                                \ # 証明書の規格
              -nodes                                               \ # 秘密鍵にパスフレーズを付けない
              -sha256                                              \ # 証明書の署名アルゴリズムにSHA-256を使用
              -days 3650                                           \ # 証明書の有効期限(単位:日)
              -newkey rsa：2048                                    \ # 作成する秘密鍵で使用する暗号方式と鍵のサイズを指定
              -keyout /etc/httpd/ssl/private/apache-selfsigned.key \ # 作成する秘密鍵のファイル名を指定
              -out /etc/httpd/ssl/apache-selfsigned.crt              # 作成するSSLサーバ証明書のファイル名を指定
```
```
# vi /etc/httpd/conf.d/ssl.conf
```
```
-  ServerName example.com:443
+  ServerName <hostname>:443

+  Header set Strict-Transport-Security "max-age=315360000; includeSubDomains"

-  SSLCertificateFile
+  SSLCertificateFile /etc/httpd/ssl/apache-selfsigned.crt

-  SSLCertificateKeyFile
+  SSLCertificateKeyFile /etc/httpd/ssl/private/apache-selfsigned.key
```
