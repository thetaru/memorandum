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
|サービス名|ポート番号|
|:---|:---|
|squid.service|3128|

## ■ 主設定ファイル squid.conf
### ● ディレクティブ
#### acl
### 文法チェック
```
# squid -k parse
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
## ■ 参考
https://straypenguin.winfield-net.com/
