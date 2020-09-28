# HTTPS対応Proxy
SELinuxが無効化されていることを前提に進めます。
```
# mkdir -p /etc/squid/ssl_cert
# chmod 700 /etc/squid/ssl_cert
# cd /etc/squid/ssl_cert
```
```
### 鍵と証明書を生成
# openssl req -x509 -newkey rsa:4096 -sha256 -nodes -keyout server.key -out server.crt -days 3650
```
```
### 確認
# ll
```
```
-rw-r--r-- 1 root root 1911  9月 28 14:33 server.crt
-rw-r--r-- 1 root root 3272  9月 28 14:33 server.key
```
```
# /usr/lib64/squid/ssl_crtd -c -s /var/lib/ssl_db/ -M 4MB
```
`squid.conf`の設定
```
# vi /etc/squid/squid.conf
```
```
-  http_proxy 8080
+  http_proxy 8080 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB cert=/etc/squid/ssl_cert/server.crt key=/etc/squid/ssl_cert/server.key
```
```
# systemctl restart squid
```
