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
### シンタックス
```
directory client(option,option...) client(option,option...) ...
```
### パラメータ
|オプション|説明|
|:---|:---|
|fsid=num||
|ro</br>rw|読み取り専用で共有する</br>読み書き両用で共有する|
|sync</br>async||
|root_squash</br>no_root_squash||
|all_squash</br>no_all_squash||
|anonuid=xxx</br>anongid=xxx||
|no_subtree_check</br>subtree_check||
|secure</br>insecure||
|hide</br>nohide||

### 設定例
```
/               master(rw) trusty(rw,no_root_squash)
/projects       proj*.local.domain(rw)
/usr            *.local.domain(ro) @trusted(rw)
/home/joe       pc001(rw,all_squash,anonuid=150,anongid=100)
/pub            *(ro,insecure,all_squash)
/srv/www        -sync,rw server @trusted @external(ro)
/foo            2001:db8:9:e54::/64(rw) 192.0.2.0/24(rw)
/build          buildhost[0-9].local.domain(rw)
```

### 文法チェック

## ■ 設定ファイル /etc/nfs.conf
### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_server/nfs.conf.parameters)にまとめました。

### ● 設定例
### ● 文法チェック

## ■ 設定ファイル /etc/nfsmount.conf
### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_server/)にまとめました。

### ● 設定例
### ● 文法チェック

## ■ 設定ファイル /etc/idmapd.conf
### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_server/)にまとめました。

### ● 設定例
### ● 文法チェック

## ■ セキュリティ
### firewall
ファイアウォールを使用する場合は、nfs-server.serviceが使用するポートの固定が必須となります。
## ■ チューニング
### ● I/Oのサイズ(最大ブロックサイズ)の変更
### ● 自動マウントの処理

## ■ 設定の反映
`/etc/exports`で指定したNFSの公開領域を反映させます。
```
# exportfs -rav
```
このとき、不必要な領域を晒していないことを確認しましょう。  
  
サービスの再起動を実施し、設定を読み込みます。
```
# systemctl restart nfs-server.service
```
