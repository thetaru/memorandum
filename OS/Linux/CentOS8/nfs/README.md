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



# Client側の設定
