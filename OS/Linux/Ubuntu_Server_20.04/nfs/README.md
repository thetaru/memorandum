# NFS
|役割|IPアドレス|
|:---|:---|
|Server|192.168.137.5|
|Client|192.168.137.6|

# Server側の設定
# Client側の設定
## § NFS Install
```
# apt-get -y install nfs-common
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
