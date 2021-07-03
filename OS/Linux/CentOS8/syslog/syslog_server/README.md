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
### ● 説明項目
#### Converting older formats to advanced
[こちら]()にまとめました。

#### Basic Structure
[こちら]()にまとめました。

#### Templates
[こちら]()にまとめました。

#### rsyslog Properties
[こちら]()にまとめました。

#### Filter Conditions
[こちら]()にまとめました。

#### RainerScript
[こちら]()にまとめました。

#### Actions
[こちら]()にまとめました。

#### timezone
[こちら]()にまとめました。

#### Modules
[こちら]()にまとめました。

### ● 設定例
### ● 文法チェック
```
# rsyslogd -N 1
```
## ■ 設定ファイル /etc/sysconfig/rsyslog
### ● SYSLOGD_OPTIONS
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
## ■ 参考
https://straypenguin.winfield-net.com/
