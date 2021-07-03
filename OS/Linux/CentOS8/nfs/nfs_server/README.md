# NFSサーバの構築
## ■ インストール
```
# yum install nfs-utils
```
## ■ バージョンの確認
```
# rpm -qa | grep nfs-utils
```
## ■ サービスの起動
```
# systemctl enable --now nfs-server.service
```
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|nfs-server.service|-|rpc.statd, rpc.mount|
|rpcbind.service|111/tcp, 111/udp||

## ■ 設定ファイル /etc/exports
### zzzパラメータ
### 設定例
### 文法チェック

## ■ 設定ファイル /etc/nfs.conf
### zzzパラメータ
### 設定例
### 文法チェック

## ■ 設定ファイル /etc/nfsmount.conf
### zzzパラメータ
### 設定例
### 文法チェック

## ■ セキュリティ
### firewall
ファイアウォールを使用する場合は、nfs-server.serviceが使用するポートの固定は必須となります。
## ■ チューニング
ソフトマウント、ハードマウント、ネットワーク系とか
## ■ 設定の反映
```
# systemctl restart nfs-server.service
```
