# chronyサーバの構築
ntpdサービスとは共存できないため、ntpdサービスが動作している場合は停止します。
## ■ インストール
```
# yum install chrony
```
## ■ バージョンの確認
```
# chronyc -v
```
## ■ サービスの起動
```
# systemctl enable --now chronyd.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|chronyd.service|123/udp|クライアント接続用|
|chronyd.service|323/udp|chronycコマンド用(自身のみ接続可)|

## ■ 主設定ファイル /etc/chrony.conf
### ● 設定項目
ディレクティブは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/chrony/chrony_server/directives)にまとめました。

### ● 文法チェック
```
# chronyd -p
```

## ■ 設定ファイル /etc/sysconfig/chronyd
IPv6を使用しない場合は、IPv4のみを指定します。
```
-  OPTIONS=""
+  OPTIONS="-4"
```

## ■ セキュリティ
### ● firewall
- 123/udp

## ■ 設定の反映
```
# systemctl restart chronyd.service
```

## ■ 設定の確認
### ● 設定値の確認
```
# chronyd -p
```

### ● リッスンポートの確認
想定通りのポートでリッスンしていることを確認します。
```
# ss -lntu | grep 123
```

### ● 起動オプションの確認
`/etc/sysconfig/chronyd`で設定したオプションがプロセスに渡されていることを確認します。
```
# ps -fup $(pgrep chronyd)
```

### ● 上位NTPサーバとの同期確認
時刻同期可能な上位NTPサーバが想定通りであることを確認します。
```
# chronyc sources -v
```
各上位NTPサーバとやりとりできることを確認します。
```
# chronyc ntpdata
```

### ● NTPクライアントとの同期確認
NTPクライアントとやりとりできることを確認します。
```
# chronyc clients
```

### ● パフォーマンスの確認
想定するstratum(上位NTPサーバのstratum-1)であることや、時刻遅延が起きていないことなどを確認します。
```
# chronyc tracking
```

## ■ 負荷テスト項目
- クライアントN台からの時刻同期に耐えられること

## ■ 監視項目
- ポート監視
  - 単位: -
  - 説明: 123/tcpでListen
- 同期先NTPサーバ
  - 単位: -
  - 説明: 時刻同期先のNTPサーバ
- オフセット
  - 単位: ms
  - 説明: 参照先と参照元の時刻差
- ドリフト
  - 単位: PPM
  - 説明: 時刻の進み遅れの度合い
- ポーリング間隔
  - 単位: s
  - 説明: 時刻同期先のNTPサーバとの同期頻度
