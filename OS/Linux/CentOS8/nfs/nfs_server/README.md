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
### オプション
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
|root_squash|クライアント側の root からのファイルの読み出し/書き込み要求を、匿名ユーザからの要求として扱う|
|no_root_squash|root_squash オプション機能の無効化</br>クライアント側の root からのファイルの読み出し/書き込み要求を root からの要求として扱う|
|all_squash|クライアント側のすべてのユーザーからの読み出し/書き込み要求を、匿名ユーザーからの要求として扱う|
|no_all_squash|クライアント側の root 以外のユーザーからの読み出し/書き込み要求を、クライアントからの要求として扱う</br>ただしクライアント側とサーバ側で、UIDとGIDを一致させておく必要がある|
|anonuid=UID</br>anongid=GID|クライアントからの読み出し/書き込み要求があったとき、そのクライアントは、このオプションで設定されたUID,GIDを持つ匿名ユーザーとして扱われる</br>UID/GIDの仕組みを持たないOS（Windowsなど）をNFSクライアントとする場合、それらのOSが利用する公開ディレクトリの設定に適用する|

### 設定例
#### ● 単純なエクスポート
#### ● 複数のディレクトリを別々にエクスポート

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
このとき、不必要な領域を晒していないことを確認しましょう。(特に、クライアントが<world>となっていたら注意)  
  
サービスの再起動を実施し、設定を読み込みます。
```
# systemctl restart nfs-server.service
```
