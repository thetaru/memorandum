# NFSクライアントの設定
## ■ インストール
```
# yum install nfs-utils
```
## ■ バージョンの確認
```
# rpm -qa | grep nfs-utils
```

## ■ 設定ファイル /etc/nfsmount.conf
NFSマウントの際のデフォルト値を変更

### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_client/nfsmount.conf.parameter)にまとめました。

## ■ 設定ファイル /etc/idmapd.conf

### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_client/idmapd.conf.parameter)にまとめました。

## ■ 設定ファイル /etc/fstab
OS起動時にシステムがどのデバイスがどのディレクトリにマウントするかを記述します。

### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_client/fstab.parameter)にまとめました。

## ■ 自動マウントについて
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_client/automount)にまとめました。

## ■ 検証用コマンド
### Linux
```
# mount -v -t nfs -o vers=(3|4) <nfs server>:<export> マウントポイント
```

### Windows
```
# mount <nfs server>:<export> マウントドライブ:\
```

## ■ トラブルシューティング
### ● NO SUCH FILE OR DIRECTORY
NFSサーバ側のexportsファイルでfsid=0を指定したら失敗する
> NFSサーバー側のマウントを`/`にしてみてください。  
> fsid=0は疑似ルートの設定なので`/`を指定してあげる必要があります。

### ● Windowsでマウントできない#1
共有の詳細設定から`ネットワーク検索を有効にする`にチェックを入れる  
設定をしても元に戻る場合は以下のサービスを自動にする
- Function Discovery Resource Publication
- SSDP Discovery
- UPnP Device Host

### ● Windowsでマウントできない#2
Windowsの標準NFSクライアントはNFSv3のみなのでNFSv4でマウントできないことに注意しましょう。  
Windows用NFSv4クライアントは以下のサイトで提供されいています。
- https://www.cohortfs.com/project/windows-nfs-clients

※ ただし、サーバ機能としてNFSv4はサポートしています
