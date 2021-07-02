# HAProxyサーバの構築
## ■ インストール
最新版を入れる場合はソースからビルドする必要があります。
```
# yum install haproxy
```
## ■ サービスの起動
サービスの起動と共に自動起動の有効化もします。
```
# systemctl enable --now haproxy.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|haproxy.service|任意||

## ■ 主設定ファイル haproxy.cfg
### ● 設定項目
#### globalセクション
このセクションで設定するパラメータは、プロセス全体、OS固有のものであり、他のセクションで再設定する必要はありません。  
globalセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/global_keywords)にまとめました。
#### defaultsセクション
defaultsセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/other_keywords)にまとめました。
#### frontendセクション
frontendセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/other_keywords)にまとめました。
#### backendセクション
backendセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/other_keywords)にまとめました。
#### resolversセクション
resolversセクションで使えるパラメータは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/haproxy/haproxy_server/other_keywords)にまとめました。
### ● 設定例
```
```
### ● 文法チェック
```
# haproxy -f /etc/haproxy/haproxy.cfg -c
```
## ■ セキュリティ
## firewall
## 証明書
## 認証
## ■ ログ
## ■ ログローテーション
## ■ チューニング
## ■ 設定の反映
```
# systemctl restart haproxy.service
```
## ■ トラブルシューティング
