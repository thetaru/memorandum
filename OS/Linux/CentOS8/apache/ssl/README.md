# HTTPS対応
## ■ SSL
```
# yum install mod_ssl
```
```
# mkdir -p /etc/httpd/ssl/private
# chmod 700 /etc/httpd/ssl/private
# openssl req -x509                                                \ #
              -nodes                                               \ #
              -days 3650                                           \ #
              -newkey rsa：2048                                    \ #
              -keyout /etc/httpd/ssl/private/apache-selfsigned.key \ #
              -out /etc/httpd/ssl/apache-selfsigned.crt              #
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
## ■ HSTS
```
# vi /etc/httpd/conf/httpd.conf
```
```
+  <VirtualHost *:80>
+     <IfModule mod_rewrite.c>
+       RewriteEngine on
+       RewriteCond %{HTTPS} off
+       RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [R,L]
+     </IfModule>
+  </VirtualHost>
```
