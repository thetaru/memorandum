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
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/SSH/ssh_server/parameters)にまとめました。
### 設定例
### 文法チェック
```
# ssh -t
```
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
