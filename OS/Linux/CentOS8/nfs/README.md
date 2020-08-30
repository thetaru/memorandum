# NFS
# Server側の設定
## § NFS Install
```
# yum -y install nfs-utils
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
|rw||
|sync||
|no_all_squash||
|root_squash||
```
# vi /etc/exports
```
```
+  /var/share/nfs 192.168.137.0/24(rw)
```
## § Export
```
# exportfs -arv
```
```
exporting 192.168.137.0/24:/var/share/nfs
```
# Client側の設定
書く予定
