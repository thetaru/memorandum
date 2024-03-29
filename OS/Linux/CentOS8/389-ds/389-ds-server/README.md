## ■ インストール
```
### cockpit
# dnf install cockpit

### 389-ds
# dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
# dnf config-manager --set-enabled powertools
# dnf module install 389-directory-server:stable/default
```
## ■ 初期設定
### インスタンス作成
Cockpitから作成します。  
ツール - 389 Directory Server - Create New Instance
|項目名|設定例|説明|備考|
|:---|:---|:---|:---|
|Instance Name||||
|Port||||
|Secure Port	||||
|||||
|||||
|||||
|||||
|||||
|||||

### ルート証明書のインポート
cockpitからインポートします。  
ツール - 389 Directory Server - Server Setting - Secutiry - Security Setting - Certificate Management - Trusted Certificate Authorites - Add CA Certificate
|項目名|設定例|説明|備考|
|:---|:---|:---|:---|
|Certificate File||||
|Certificate Nickname||||

### サーバ証明書のインポート
PKCS#12形式の証明書を作成します。
```
# openssl pkcs12 -export -in server.crt -inkey server.key -out server.p12 -nodes -name Server-Cert
Enter Export Password: password
Verifying - Enter Export Password: password
```

### LDAPSの有効化
cockpitから有効化します。  
ツール - 389 Directory Server - Server Setting - Secutiry - Security Setting - Security Configuration - Security Enabled

## ■ バージョンの確認
## ■ サービスの起動
```
### cockpit
# systemctl enable --now cockpit.socket
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|ldap|389/tcp||
|ldaps|636/tcp|
|cockpit|9090/tcp|

## ■ 主設定ファイル xxx.conf
### ● xxxセクション
### ● yyyディレクティブ
- aaa(recommended)
- bbb
### ● zzzパラメータ
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ログ
## ■ ログローテーション
## ■ チューニング
## ■ 設定の反映
## ■ 設定の確認
## ■ 負荷テスト項目
## ■ 監視項目
## ■ Ref
- https://event.ospn.jp/osc2020-online-do/session/100667
