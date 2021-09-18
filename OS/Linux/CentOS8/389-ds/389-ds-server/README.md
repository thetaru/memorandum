## ■ インストール
```
### cockpit
# dnf install cockpit

### 389-ds
# dnf module list | grep 389
# dnf module enable 389-ds
# dnf install 389-ds-base
```
## ■ 初期設定
```
# dscreate interactive
```
```
Install Directory Server (interactive mode)
===========================================
selinux is disabled, will not relabel ports or files.

Selinux support will be disabled, continue? [yes]:

Enter system's hostname [ldap-01]:

Enter the instance name [ldap-01]:

Enter port number [389]:

Create self-signed certificate database [yes]:

Enter secure port number [636]:

Enter Directory Manager DN [cn=Directory Manager]:

Enter the Directory Manager password:
Confirm the Directory Manager Password:

Enter the database suffix (or enter "none" to skip) [dc=ldap-01]: dc=ldap-01,dc=jp

Create sample entries in the suffix [no]:

Create just the top suffix entry [no]: yes

Do you want to start the instance after the installation? [yes]:

Are you ready to install? [no]: yes
Starting installation...
Completed installation for ldap-01
```
## ■ バージョンの確認
## ■ サービスの起動
```
### cockpit
# systemctl enable --now cockpit.socket

### 389-ds
#
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||||

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
