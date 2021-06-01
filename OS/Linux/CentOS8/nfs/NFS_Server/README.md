# NFSサーバの構築
|役割|IPアドレス|
|:---|:---|
|Server|192.168.137.100|
|Client|192.168.137.101|

|NFSサーバ|設定値|
|:---|:---|
|公開ディレクトリ|/var/share/nfs|

|NFSクライアント|設定値|
|:---|:---|
|マウントポイント|/share/nfs-client|

# Server側の設定
## § NFS Install
```
# yum -y install rpcbind nfs-utils
```
## § NFS共有先の作成
共有用のディレクトリを作成します。
```
# mkdir -p /var/share/nfs
```
## § 設定事項
### アクセス制限
#### Syntax
```
<共有ディレクトリへのPATH> <接続許可ネットワーク>(<オプション>)
```
|パラメータ|意味|
|:---|:---|
|ro|読み出し専用で共有します。クライアントは書き込むことができません。|
|rw|クライアントは読み書き込み両方でアクセスできます。|
|async|デフォルトは同期だが非同期にする。|
|root_squash|rootユーザからのリクエストをanonymousに格下げする。デフォルトはno_all_squash。|

```
# vi /etc/exports
```
```
+  /var/share/nfs 192.168.137.0/24(rw,no_root_squash,async)
```
`/etc/exports`の内容を反映させます。
```
# exportfs -rav
```
```
exporting 192.168.137.0/24:/var/share/nfs
```
### [Option]ポートの固定化
Firewallでポートを指定して接続元を絞るときは必須となります。
```
# vi /etc/nfs.mount
```
```
[lockd]
port = 2052
udp-port = 2052
[mountd]
port = 2050
[statd]
port = 2051
```
### ドメイン設定
`DOMAIN`の値はサーバとクライアントで共通のドメイン名を指定します。
以下は、`DOMAIN`が`WORKGROUP`であると仮定しています。
```
# vi /etc/idmapd.conf
```
```
-  #Domain = WORKGROUP
+  Domain = WORKGROUP
```
## § サービスの起動
```
# systemctl start nfs-server
# systemctl enable nfs-server
```
```
### 起動確認
# systemctl status nfs-server
```
## § チューニング
#### スレッド数
```
# vi /etc/nfs.mount
```
```
[nfsd]
-  threads = 8
+  threads = 16
```
#### I/Oサイズ変更
```
# /etc/tmpfiles.d/nfsd-block-size.conf
```
```
w /proc/fs/nfsd/max_block_size - - - - 32768
```
