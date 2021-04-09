# NFSクライアントの設定
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
