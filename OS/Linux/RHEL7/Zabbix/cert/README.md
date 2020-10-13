# Zabbixの通信暗号化設定
証明書ベースの設定方法  
これを参考に書き直し?  
https://qiita.com/mitzi2funk/items/602d9c5377f52cb60e54  
|ホスト名|役割|プロンプト|
|:---|:---|:---|
|Zabbix_Server|監視する側|[Server]#|
|Zabbix_Client|監視される側|[Client]#|

## ■ プライベート認証局(CA)の構築
```
### プライベート認証局(CA)作成用のopenssl設定
[Server]# vi /etc/pki/tls/openssl.cnf
```
```
[ usr_cert ]
-  basicConstraints=CA:FALSE
+  basicConstraints=CA:TRUE

[ v3_ca ]
-  # nsCertType = sslCA, emailCA
+  nsCertType = sslCA, emailCA
```
```
### 証明書の有効期限を10年に変更
[Server]# vi /etc/pki/tls/misc/CA
```
```
-  CADAYS="-days 1095" # 3 years
+  CADAYS="-days 3650" # 10 years
```
`/etc/pki/CA/`下に証明書のラベル付けに使用するシリアルファイルを作成します。
```
[Server]# echo '1000' > /etc/pki/CA/serial
```
認証局(CA)を作成します。
```
[Server]# /etc/pki/tls/misc/CA -newca
```
```
CA certificate filename (or enter to create) <Enter>

Enter PEM pass phrase: <password>
Verifying - Enter PEM pass phrase: <password>

Country Name (2 letter code) [XX]: JP
State or Province Name (full name) []: Tokyo
Locality Name (eg, city) [Default City]: <Enter>
Organization Name (eg, company) [Default Company Ltd]: <Enter>
Organizational Unit Name (eg, section) []: <Enter>
Common Name (eg, your name or your server's hostname) []: Zabbix CA
Email Address []: <Enter>

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []: <Enter>
An optional company name []: <Enter>
Using configuration from /etc/pki/tls/openssl.cnf
Enter pass phrase for /etc/pki/CA/private/./cakey.pem: <password>
Check that the request matches the signature
Signature ok

Certificate is to be certified until MM DD xx:xx:xx yyyy GMT (3650 days)

Write out database with 1 new entries
Data Base Updated
```
認証局(CA)秘密鍵のパスフレーズを除去します。
```
[Server]# cd /etc/pki/CA/private
[Server]# openssl rsa -in cakey.pem -out cakey.pem
Enter pass phrase for cakey.pem: <password>
```
認証局(CA)秘密鍵のパーミションを変更
```
[Server]# chmod 400 /etc/pki/CA/private/cakey.pem
```
以上で、プライベート認証局(CA)の構築完了です。
## ■ Zabbix用のサーバ・クライアント証明書の作成
プライベート認証局の証明書`/etc/pki/CA/cacert.pem`を`/var/lib/zabbix`にコピーします。
```
[Server]# mkdir /var/lib/zabbix
[Server]# chown zabbix:zabbix /var/lib/zabbix/
[Server]# chmod 700 /var/lib/zabbix/
[Server]# cp -i /etc/pki/CA/cacert.pem /var/lib/zabbix/zabbix_ca_file
```
次に、Zabbix用のサーバ・クライアント証明書を署名します。  
今回は、作成した証明書と秘密鍵をZabbixサーバとZabbixエージェント共通で使います。
```
[Server]# cd /var/lib/zabbix/
```
```
### 秘密鍵の作成
[Server]# openssl genrsa -out zabbix.key 2048
```
```
### 証明書発行要求(CSR)の作成
[Server]# openssl req -new -key zabbix.key -out zabbix.csr
```
```
Country Name (2 letter code) [XX]: JP
State or Province Name (full name) []: Tokyo
Locality Name (eg, city) [Default City]: <Enter>
Organization Name (eg, company) [Default Company Ltd]: <Enter>
Organizational Unit Name (eg, section) []: <Enter>
Common Name (eg, your name or your server's hostname) []: Zabbix CSR
Email Address []: <Enter>

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []: <Enter>
An optional company name []: <Enter>
```
サーバ・クライアント証明書の作成用にopenssl の設定を変更します。
```
[Server]# vi /etc/pki/tls/openssl.cnf
```
```
[ CA_default ]
-  default_days = 365
+  default_days = 3650

[ usr_cert ]
-  basicConstraints=CA:TRUE
+  basicConstraints=CA:FALSE

-  # nsCertType = server
+  nsCertType = server, client
```
作成した証明書発行要求(CSR)を元に、証明書(CRT)を作成します。
```
[Server]# openssl ca -in zabbix.csr -out zabbix.crt
```
```
Using configuration from /etc/pki/tls/openssl.cnf
Check that the request matches the signature
Signature ok

Certificate is to be certified until MM DD xx:xx:xx yyyy GMT (3650 days)
Sign the certificate? [y/n]: y

1 out of 1 certificate requests certified, commit? [y/n] y
Write out database with 1 new entries
Data Base Updated
```
```
[Server]# rm zabbix.csr
[Server]# chown zabbix:zabbix /var/lib/zabbix/zabbix*
[Server]# chmod 400 /var/lib/zabbix/zabbix*
[Server]# ll /var/lib/zabbix/
```
```
-r-------- 1 zabbix zabbix 4502 10月 13 13:14 zabbix.crt
-r-------- 1 zabbix zabbix 1675 10月 13 13:12 zabbix.key
-r-------- 1 zabbix zabbix 4362 10月 13 13:12 zabbix_ca_file
```
以上でZabbix用のサーバ・クライアント証明書の作成完了です。
## ■ Zabbixサーバの設定
```
[Server]# sed -i.bak -e 's|# TLSCAFile=|TLSCAFile=/var/lib/zabbix/zabbix_ca_file|g' \
                     -e 's|# TLSCertFile=|TLSCertFile=/var/lib/zabbix/zabbix.crt|' \
                     -e 's|# TLSKeyFile=|TLSKeyFile=/var/lib/zabbix/zabbix.key|' /etc/zabbix/zabbix_server.conf
```
設定が終わったら Zabbixサーバを再起動します。
```
[Server]# systemctl restart zabbix-server
```
## ■ Zabbixエージェントの設定
Zabbixサーバから作成した`zabbix_ca_file`, `zabbix.crt`, `zabbix.key`をZabbixクライアントへコピーします。
```
[Client]# mkdir /var/lib/zabbix
[Client]# scp <user>@<Zabbix Client IP Addr>:/var/lib/zabbix/* /var/lib/zabbix
[Client]# chown -R zabbix:zabbix /var/lib/zabbix
[Client]# chmod 700 /var/lib/zabbix
[Client]# chmod 400 /var/lib/zabbix/zabbix*
```
```
[Client]# vi /etc/zabbix/zabbix_agentd.conf
```
```
-  # TLSConnect=
+  TLSConnect=cert

-  # TLSAccept=
+  TLSAccept=cert

-  # TLSCAFile=
+  TLSCAFile=/var/lib/zabbix/zabbix_ca_file

-  # TLSCertFile=
+  TLSCertFile=/var/lib/zabbix/zabbix.crt

-  # TLSKeyFile=
+  TLSKeyFile=/var/lib/zabbix/zabbix.key
```
```
[Client]# systemctl restart zabbix-agent
```
## ■ 暗号化されていることの確認
暗号化されていることの確認
```
[Server]# tcpdump port 10051 -i ensxxx -X
```
