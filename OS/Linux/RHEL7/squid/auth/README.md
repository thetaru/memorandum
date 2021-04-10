# Basic認証について

|ユーザ名|パスワード|
|:---|:---|
|user01|password01|
|user02|password02|

## パスワード設定
user01のBasic認証のための設定をします。  
設定したユーザ名とパスワードの対応は`/etc/squid/squid.pass`に保存されます。  
※ `/etc/squid/.htpasswd`のファイル名はなんでもよいです。(ただし、コマンド実行毎に変更するのはNG)
```
# htpasswd -c /etc/squid/.htpasswd user01
New password:          <- password01と入力
Re-type new password:  <- password01と入力
Adding password for user user01
```
Basic認証を許可するために`squid.conf`を編集します。
```
# vi /etc/squid/squid.conf
```
```
+  auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/.htpasswd
+  auth_param basic children 5 startup=5 idle=1
+  auth_param basic realm Squid proxy-caching web server
+  auth_param basic credentialsttl 2 hours
+  acl staff proxy_auth REQUIRED
```

## ユーザの追加・削除
### 新規作成
```
# htpasswd -c /etc/squid/.htpasswd user01
```
### 追加
```
# htpasswd -b /etc/squid/.htpasswd user02
```
### 削除
```
# htpasswd -D /etc/squid/.htpasswd user01
```
