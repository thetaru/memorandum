# NFS
|役割|IPアドレス|
|:---|:---|
|Server|192.168.137.100|
|Client|192.168.137.101|

# Server側の設定
## § NFS Install
```
# yum -y install nfs-utils
```
## § バージョン確認
```
### nfsプロトコルのバージョン確認
# rpcinfo -p | grep -e nfs -e vers
```
```
   program vers proto   port  service
    100003    3   tcp   2049  nfs
    100003    4   tcp   2049  nfs
    100227    3   tcp   2049  nfs_acl
```
## § NFS共有先の作成
```
# mkdir -p /var/share/nfs
```
```
### ファイルの権限制限回避
# chown -R nobody: /var/share/nfs
# chmod -R 777 /var/share/nfs
```
```
### 変更の有効化
# systemctl restart nfs-utils.service
```
## § アクセス制限
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
## § サービスの起動
```
# systemctl start nfs-server.service
# systemctl enable nfs-server.service
```
```
### 起動確認
# systemctl status nfs-server.service
```
## § Export
```
# exportfs -rav
```
```
exporting 192.168.137.0/24:/var/share/nfs
```
# Client側の設定
## § NFS Install
```
# yum -y install nfs-utils
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
