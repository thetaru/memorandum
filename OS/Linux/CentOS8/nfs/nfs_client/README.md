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
```
# mount -v -t nfs -o vers=(3|4) <nfs server>:<export> マウントポイント
```

## ■ トラブルシューティング
### ● NFSv4でマウントできない
- NFSサーバ側のexportsファイルでfsid=0を指定したら失敗する
