# sshサーバの構築
## ■ インストール
```
# yum install openssh-server
```
## ■ バージョンの確認
```
# ssh -V
```
## ■ サービスの起動
```
# systemctl enable --now sshd.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|sshd.service|22/tcp||

## ■ 主設定ファイル /etc/ssh/sshd_config
### パラメータ
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/SSH/ssh_server/parameters)にまとめました。
### 設定例
### 文法チェック
```
# sshd -t
```
## ■ 設定ファイル /etc/sysconfig/sshd
## ■ セキュリティ
### ● firewall
- 22/tcp
### ● 認証
- パスワード認証
- 公開鍵認証
- LDAP認証
- LDAP + Kerberos認証

## ■ ログ
CentOS8のデフォルト設定では、SSHのログのファシリティはAUTHPRIV(レベルはINFO)なので、rsyslogにより`/var/log/secure`に振り分けられます。

## ■ 設定の反映
サービスの再起動を実施し、設定を読み込みます。
```
# systemctl restart sshd.service
```
設定が読み込まれていることを確認します。
```
# sshd -T
```
grepなどして変更箇所を確認しましょう。
