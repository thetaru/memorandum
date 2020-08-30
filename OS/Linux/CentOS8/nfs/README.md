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
## NFS共有先の作成
```
# mkdir -p /mnt/nfs_shares/docs
```
```
### ファイルの権限制限回避
# chown -R nobody: /mnt/nfs_shares/docs
# chmod -R 777 /mnt/nfs_shares/docs
```
```
### 変更の有効化
# systemctl restart nfs-utils.service
```
# Client側の設定
