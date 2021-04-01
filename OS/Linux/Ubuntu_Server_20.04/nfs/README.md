# NFS
|役割|IPアドレス|
|:---|:---|
|Server|192.168.137.5|
|Client|192.168.137.6|

|情報|設定値|
|:---|:---|
|公開ディレクトリ|/var/share/nfs|
|マウントポイント|/share/nfs-client|

# Server側の設定
## § NFS Install
```
# apt-get -y install nfs-kernel-server
```
# Client側の設定
## § NFS Install
```
# apt-get -y install nfs-common
```
設定等はCentOS8と同一なので省略します。
