# postfixサーバーの構築
## ■ インストール
```
# yum install postfix
```
## ■ バージョンの確認
```
# postconf | grep mail_version
```
## ■ サービスの起動
```
# systemctl enable --now postfix.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|postfix.service|25/tcp||

## ■ 主設定ファイル /etc/postfix/main.cf
### ● パラメータ
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/postfix/postfix_summary)にまとめました。
### ● 設定例
### ● 文法チェック
```
# postfix check
```
## ■ 設定ファイル /etc/postfix/transport
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ログ
## ■ ログローテーション
## ■ チューニング
## ■ トラブルシューティング
## ■ 設定の反映
サービスの再起動を実施し、設定を読み込みます。
```
# systemctl restart postfix.service
```
設定が読み込まれていることを確認します。
```
### すべてのパラメータを表示
# postconf

### デフォルト値から変更されたパラメータを表示
# postconf -n
```
## ■ 参考

