# chronyサーバの構築
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
|chronyd.service|123/udp||

## ■ 主設定ファイル /etc/chrony.conf
### ● 設定項目
ディレクティブは[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/chrony/chrony_server/directives)にまとめました。

### ● 文法チェック
```
# chronyd -p
```

## ■ 設定ファイル /etc/sysconfig/chronyd

## ■ セキュリティ
### ● firewall

## ■ 設定の反映
```
# systemctl restart chronyd.service
```

## ■ 設定の確認
