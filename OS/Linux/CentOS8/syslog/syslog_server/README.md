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
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/ConvertingOlderFormatsToAdvanced)にまとめました。

#### Basic Structure
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/BasicStructure)にまとめました。

#### Templates
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/Templates)にまとめました。

#### rsyslog Properties
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/RsyslogProperties)にまとめました。

#### Filter Conditions
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/FilterConditions)にまとめました。

#### RainerScript
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/RainerScript)にまとめました。

#### Actions
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/Actions)にまとめました。

#### timezone
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/Timezone)にまとめました。

#### Modules
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server/Modules)にまとめました。

### ● 設定例
|項目|設定値|
|:---|:---|
|Listenポート|514/tcp|

```
```
### ● 文法チェック
```
# rsyslogd -N 1
```
## ■ 設定ファイル /etc/sysconfig/rsyslog
### ● SYSLOGD_OPTIONS
## ■ セキュリティ
### ● firewall
### ● 証明書
## ■ チューニング
## ■ 設定の反映
```
# systemctl restart rsyslog.service
```
