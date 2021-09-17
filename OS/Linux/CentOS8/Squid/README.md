# squidサーバ(フォワードプロキシ)の構築
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
|squid.service|3128/tcp|squidのlistenポート|
|squid.service|3401/udp|snmpエージェントのlistenポート|

## ■ 主設定ファイル squid.conf
### ● ディレクティブ
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Squid/directives)にまとめました。

### ● 設定例
- 指定したドメインのみアクセス可能とする(ホワイトリスト方式)
- 指定したドメインのみアクセス不可とする(ブラックリスト方式)

### ● 文法チェック
```
# squid -k parse
# squid -k check
```

## ■ セキュリティ
### ● firewall
- 3128/tcp
- 3401/udp

※ 設定に依存するため注意すること

### ● 認証
- Basic認証
- Kerberos認証
- LDAP認証

## ■ ロギング
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Squid/logging)にまとめました。

## ■ チューニング
### ● カーネルパラメータ
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/Squid/kernelparameters)にまとめました。

### ● ファイルディスクリプタ
```
# mkdir -p /etc/systemd/system/squid.service.d

# cat <<EOF > /etc/systemd/system/squid.service.d/override.conf
[Service]
LimitNOFILE=100000
EOF

# systemctl daemon-reload
```

## ■ トラブルシューティング
- クライアントの問い合わせに対する名前解決はサーバ側で行う件について  
  
※ パラメータでクライアントに名前解決させることも可能
## ■ 設定の反映
```
# systemctl restart squid.service
```
## ■ 設定の確認
- 指定のポートからインターネットに接続できること
- 実装した認証方法で利用できること
- キャッシュを利用(している|していない)こと
- ログのフォーマットが想定通りであること
- ログローテーションが行われていること
- (要件次第)上位プロキシを経由しインターネットに接続できること

## ■ 負荷テスト項目
- XXXrpsのクエリ処理に耐えられること
- クライアントN台からの同時接続に耐えられること

## ■ 監視項目
- ポート監視
  - 単位: -
  - 説明: 指定のTCPポートでListen
