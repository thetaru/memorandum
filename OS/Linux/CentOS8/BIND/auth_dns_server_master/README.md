# 権威DNSサーバ(マスター)の構築
## ■ インストール
```
# yum install bind bind-chroot bind-utils
```
## ■ バージョンの確認
```
# named -v
```
## ■ サービスの起動
```
# systemctl enable --now bind-chroot.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|named-chroot.service|53/tcp,udp||

## ■ 主設定ファイル /etc/named.conf
### ● xxxセクション

### ● 設定例
### ● 文法チェック
```
# named-checkconf /etc/named.conf

# named-checkzone <ドメイン> <(ドメインに対応する)ゾーンファイル>
```
## ■ 設定ファイル /etc/sysconfig/named
```
```
## ■ セキュリティ
### ● firewall

## ■ ロギング
## ■ チューニング
## ■ 設定の反映
```
# systemctl restart named-chroot.service
```
## ■ 設定の確認
### ● ゾーン転送の確認
```
```

### ●
```
```
