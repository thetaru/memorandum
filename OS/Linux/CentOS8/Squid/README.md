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
- ホスト名が表示されないこと

サーバ側・クライアント側からホスト名が表示されないことを確認します。
```
### webページにアクセス
# curl http://www.example.com -x localhost:8081
```
- バージョンが表示されないこと

サーバ側・クライアント側からホスト名が表示されないことを確認します。
```
### webページにアクセス
# curl http://www.example.com -x localhost:8081
```
- リクエストヘッダに不要な情報が含まれないこと
  - Referer
  - User-Agent
  - X-Forwarded-For
  - Via
  - Cache-Control
- キャッシュを利用(している|していない)こと
- ログのフォーマットに必要な情報が含まれていること
- ログローテーションが行われていること
- (要件依存)ホワイトリストを適切に設定していること
  - 接続元を指定する場合、指定外のクライアントからアクセスできないことを確認する
- (要件依存)ブラックリストを適切に設定していること
  - 接続元を指定する場合、指定外のクライアントからアクセスできることを確認する
- (要件依存)上位プロキシを経由し、インターネットへ接続できること
- (要件依存)指定の認証方法で認証が行われること

## ■ 負荷テスト項目
- XXXrpsのクエリ処理に耐えられること
- クライアントN台からの同時接続に耐えられること

## ■ 監視項目
- ポート監視
  - 単位: -
  - 説明: 指定のTCPポートでListen
