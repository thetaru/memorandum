# postfixサーバーの構築
## ■ インストール
```
# yum install postfix
```
## ■ バージョンの確認
```
# 
```
## ■ サービスの起動
```
# systemctl enable --now postfix.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|postfix.service|25||

## ■ 主設定ファイル /etc/postfix/main.cf
### パラメータ
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/postfix/postfix_summary)にまとめました。
### 設定例
### 文法チェック
## ■ 設定ファイル yyy
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

