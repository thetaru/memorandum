# Basic認証について

|ユーザ名|パスワード|
|:---|:---|
|user01|password01|

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
### Basic認証用の設定
+  auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/.htpasswd
+  auth_param basic children 5 startup=5 idle=1
+  auth_param basic realm Squid proxy-caching web server
+  auth_param basic credentialsttl 2 hours

+  acl basic_ncsa proxy_auth REQUIRED
+  http_access allow basic_ncsa
```
#### 補足: ユーザのアクセス制御について
まずは設定値のここに注目してください。  
aclディレクティブとhttp_accessディレクティブで、認証ファイル(`/etc/squid/.htpasswd`)で指定したユーザを利用できるようにしておきます。  
`proxy_auth REQUIRED`とすることで、認証ファイルに登録されている全てのユーザが指定されることになります。
```
acl basic_ncsa proxy_auth REQUIRED
http_access allow basic_ncsa
```
それぞれについて解説します。
```
### Format acl acl名 proxy_auth (ユーザ名 | REQUIRED)
acl basic_ncsa proxy_auth REQUIRED
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
