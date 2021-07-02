# syslogサーバの構築
## ■ インストール
```
# yum install rsyslog
```
## ■ バージョンの確認
```
# rsyslogd -v
```
## ■ サービスの起動
```
# systemctl enable --now rsyslog.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|rsyslog.service|514/tcp,udp||

## ■ 主設定ファイル /etc/rsyslog.conf
### ● zzzパラメータ
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル /etc/sysconfig/rsyslog
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ログ
## ■ ログローテーション
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
```
# systemctl restart rsyslog.service
```
```
# rsyslogd -N 1
# rsyslogd -N 1 -c <config file>
```
## ■ 参考
https://straypenguin.winfield-net.com/
