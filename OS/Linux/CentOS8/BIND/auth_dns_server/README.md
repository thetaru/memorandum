# 権威DNSサーバの構築
## ■ インストール
```
# yum install bind bind-chroot bind-utils
```
## ■ バージョンの確認
```
# bind -v
```
## ■ サービスの起動
```
# systemctl enable --now bind-chroot.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
||||

## ■ 主設定ファイル xxx.conf
### ● xxxセクション

### ● 設定例
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall

## ■ ロギング
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
## ■ 設定の確認
