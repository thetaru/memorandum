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
|sshd.service|22||

## ■ 主設定ファイル /etc/ssh/sshd_config
### パラメータ
[こちら]()にまとめました。
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル /etc/sysconfig/sshd
## ■ セキュリティ
### ● firewall
### ● 認証
## ■ ログ
## ■ ログローテーション
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
## ■ 参考
https://straypenguin.winfield-net.com/
