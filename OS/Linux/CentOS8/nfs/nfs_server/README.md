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
|サービス名|ポート番号|備考|
|:---|:---|:---|
|portmapper|111/tcp, 111/udp|NFSv4専用の場合は不要|
|nfs|2049/tcp, 2049/udp||
|statd|不定/tcp, 不定/udp|必要に応じて固定|
|mountd|不定/tcp, 不定/udp|必要に応じて固定|
|nlockmgr|不定/tcp, 不定/udp|必要に応じて固定|

※ NFSv4プロトコルでは、`rpcbind`サービス、`lockd`サービス、`rpc-statd`サービスが不要となります。

## ■ 共有ディレクトリの作成
```
### For Windows
# mkdir -p /exports/Windows
# chown 65534:65534 /exports/Windows
# chmod 777 /exports/Windows

### For Linux
# mkdir -p /exports/Linux
## [OPTION] NFSユーザを指定してマウントする場合は以下を実行する
# groupadd -g 8888 nfsclient
# useradd -s /sbin/nologin -M -u 8888 -g 8888 nfsclient
# chown nfsclient:nfsclient /exports/Linux
```
※ UID(8888)やGID(8888)、ユーザ名(nfsclient)は必要に応じて変更してください  
※ NFSユーザを指定してマウントする場合、nfsclientユーザ(と同じUID/GIDを持つユーザ)をクライアント側も作成する必要がある

## ■ [任意] 設定ファイル /etc/netconfig
NFSはRPCを利用するので、IPv6を無効化している場合、`/etc/netconfig`でもIPv6を無効化する。

### ● 設定例
```
-  udp6       tpi_clts      v     inet6    udp     -       -
+  #udp6       tpi_clts      v     inet6    udp     -       -

-  tcp6       tpi_cots_ord  v     inet6    tcp     -       -
+  #tcp6       tpi_cots_ord  v     inet6    tcp     -       -
```

## ■ 設定ファイル /etc/exports
### ● シンタックス
```
directory client(option,option...) client(option,option...) ...
```
### ● オプション
|オプション|説明|
|:---|:---|
|ro|読み取り専用で共有する|
|rw|読み書き両用で共有する|
|secure|クライアントからのポート番号が1023以下の場合のみ接続を許可|
|insecure|クライアントのポート番号によるアクセス制御を行わない|
|sync|クライアントから書き込まれたデータを即座にディスクに書き込む|
|async|クライアントから書き込まれたデータをメモリ上のバッファにキャッシュしてから、ディスクに書き込む|
|wdelay|複数の書き込み処理が発生したとき、ディスクへの書き込みをまとめて行う|
|no_wdelay|wdealy のオプション機能を無効にする</br>sync オプション指定時のみ有効|
|hide|親子関係にある2つのディレクトリが「/etc/exports」ファイルで別々に設定されているとき、親ディレクトリをマウントしたクライアントに対し、子ディレクトリの中身は参照できないようにする|
|nohide|hide オプション機能の無効化</br>このオプションは単独のホストに対してのみ有効|
|subtree_check|ファイルシステム全体でなく、一部のディレクトリのみが公開されている場合に、クライアントからの要求されたファイルが公開ディレクトリに含まれるかどうかチェックされるようになる|
|no_subtree_check|sub_tree_check オプション機能の無効化|
|root_squash|rootユーザのリクエストを匿名ユーザに格下げ(squash)する|
|no_root_squash|rootユーザのリクエストをroot権限で実行する|
|all_squash|root以外のユーザからのリクエストを匿名ユーザに格下げ(squash)する|
|no_all_squash|すべてのユーザからリクエストを匿名ユーザに格下げ(squash)する|
|anonuid=UID</br>anongid=GID|root_squashまたはall_squashがオプションが有効な場合、格下げ(squash)する匿名ユーザのUID/GIDを指定できる|

### ● 設定例
#### Linux
```
# NFSv3
/exports/Linux 192.168.137.0/24(rw,no_root_squash)
/exports/Linux 192.168.137.0/24(rw,root_squash,anonuid=8888,anongid=8888)

# NFSv4
/exports/Linux 192.168.137.0/24(rw,fsid=0)
```
#### Windows
WindowsはNFSv4を使用できない(はず)
```
# NFSv3
/exports/Windows 192.168.137.0/24(rw,no_root_squash)
```

### ● 反映方法
`/etc/exports`で指定したNFSの公開領域を反映させます。
```
# exportfs -rav
```
このとき、不必要な領域を晒していないことを確認しましょう。

## ■ 設定ファイル /etc/nfs.conf
nfsサーバ全般に関する設定を行います。

### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_server/nfs.conf.parameters)にまとめました。

### ● 設定例
```
```

### ● 反映方法
```
# systemctl restart nfs-server.service
```

## ■ 設定ファイル /etc/idmapd.conf
NFSv4ではidmapdを利用したIDマッピングを行うため、NFSv4を使用する場合に設定を行います。  
少なくともドメイン名の設定を行う必要があります。

### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_server/idmapd.conf.parameter)にまとめました。

### ● 設定例
```
```

### ● 反映方法
```
# echo N > /sys/module/nfsd/parameters/nfs4_disable_idmapping
# nfsidmap -c
# systemctl restart nfs-idmapd.service
```

## ■ セキュリティ
### firewall
ファイアウォールを使用する場合は、nfs-server.serviceが使用するポートの固定が必須となります。
#### ● NFS version3
NFS version3では利用ポートを固定する必要があります。
#### ● NFS version4
NFS version4では利用ポートが固定されています。

## ■ チューニング
### ● NFSデーモン数の調整
### ● I/Oのサイズ(最大ブロックサイズ)の変更
### ● カーネルパラメータ
候補: ファイルディスクリプタ、IO系、帯域幅系、カーネルスレッド系、コネクション系、iノード系  
キープライブとかも考慮?てかtcp全般は手を付けたほうがいいのかも?  
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_server/kernelparameters)にまとめました。

## ■ 設定の確認
### exports
```
# exportfs -v
```

### nfs.conf
指定したポートを利用していることを確認します。
```
# rpcinfo -p
```

### idmapd.conf
NFSv4の場合に確認してください。
```
# cd マウントポイント
# touch hoge
# ls -l hoge
```
指定のUID/GIDになっていることを確認してください。

## ■ Ref
- https://redj.hatenablog.com/entry/2019/03/30/134041
