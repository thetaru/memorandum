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
#### 指定したドメインのみアクセス可能とする(ホワイトリスト方式)
#### 指定したドメインのみアクセス不可とする(ブラックリスト方式)

### ● 文法チェック
```
# squid -k parse
# squid -k check
```

## ■ セキュリティ
### ● firewall
### ● 認証
#### ◆ Basic認証
#### ◆ Kerberos認証
#### ◆ LDAP認証
## ■ ロギング
### syslogサーバへの転送
access_logでsyslogモジュールを指定し、ファシリティとプライオリティにlocal1とinfoを指定したと仮定して進めます。
```
# vi /etc/rsyslog.conf
```
```
-  *.info;mail.none;authpriv.none;cron.none                /var/log/messages
+  *.info;mail.none;authpriv.none;cron.none;local1.info    /var/log/messages
```
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
- クライアントの問い合わせに対する名前解決は
サーバ側で行う件について  
  
※ パラメータでクライアントに名前解決させることも可能
## ■ 設定の反映
```
# systemctl restart squid.service
```
