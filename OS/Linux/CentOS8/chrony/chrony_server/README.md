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
### ● xxxセクション

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

## ■ 参考
https://straypenguin.winfield-net.com/
