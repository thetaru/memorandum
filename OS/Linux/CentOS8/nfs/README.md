# NFS
|役割|IPアドレス|
|:---|:---|
|Server|192.168.137.100|
|Client|192.168.137.101|

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
### ドメイン設定
`/etc/idmapd.conf`を編集します。`DOMAIN`の値はサーバとクライアントで共通のドメイン名を指定します。
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
# systemctl start nfs-idmap
# systemctl enable nfs-server
```
```
### 起動確認
# systemctl status nfs-server.service
```
## § 設定の反映
```
# exportfs -rav
```
```
exporting 192.168.137.0/24:/var/share/nfs
```
# Client側の設定
## § NFS Install
```
# yum -y install rpcbind nfs-utils
```
## § マウントの設定
```
### マウント先のディレクトリを作成
# mkdir -p /share/nfs-client
```
```
### 確認のためマウントしてみる
# mount -v -t nfs 192.168.142.100:/var/share/nfs /share/nfs-client
```
マウントすることができたら`fstab`を編集します。
```
# vi /etc/fstab
```
```
+  192.168.137.100:/var/share/nfs /share/nfs-client nfs defaults 0 0
```
再起動してOSが上がってきた後もマウントされていることを確認すること。
### IPv6無効化している場合
本質的ではないけど原因はわかる`/usr/lib/systemd/system/rpcbind.socket`
https://www.unknownengineer.net/entry/2017/02/16/163419https://www.unknownengineer.net/entry/2017/02/16/163419  
https://qiita.com/ymko/items/e1ff79efed9cf7f29348  
https://qiita.com/suzutsuki0220/items/438f374c0070a27724a3
