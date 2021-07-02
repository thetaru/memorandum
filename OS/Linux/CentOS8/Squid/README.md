# squidサーバの構築
## ■ インストール
```
# yum install squid
```
## ■ バージョンの確認
```
# squid -v | grep Version
```
## ■ サービスの起動
```
# systemctl enable --now squid.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|squid.service|3128|squidのlistenポート|
|squid.service|3401|snmpエージェントのlistenポート|

## ■ 主設定ファイル squid.conf
### ディレクティブ
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Squid/directives)にまとめました。

### 設定例

### 文法チェック
```
# squid -k parse
# squid -k check
```
## ■ セキュリティ
### firewall
### 証明書
### 認証
## ■ ログ
## ■ ログローテーション
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
```
# systemctl restart squid.service
```
## ■ 参考
https://straypenguin.winfield-net.com/
