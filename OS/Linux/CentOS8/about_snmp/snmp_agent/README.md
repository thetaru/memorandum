# SNMPエージェントの設定
## ■ インストール
## ■ バージョンの確認
```
# snmpd -v
```
## ■ サービスの起動
```
# systemctl enable --now snmpd.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|snmpd.service|161/udp||

## ■ 主設定ファイル snmpd.conf
### ● パラメータ
#### com2sec
#### group
#### view
#### access
#### syslocation
#### syscontact
#### dontLogTCPWrappersConnect
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル snmptrapd.conf
## ■ セキュリティ
### firewall
## ■ ログ
## ■ ログローテーション
## ■ 設定の反映
