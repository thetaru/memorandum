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

## ■ 設定ファイル /etc/fstab
OS起動時にシステムがどのデバイスがどのディレクトリにマウントするかを記述します。

### ● 設定項目
[こちら](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/nfs/nfs_client/fstab.parameter)にまとめました。

## ■ 検証用コマンド
```
# mount -v -t nfs -o vers=(3|4) <nfs server>:<export> マウントポイント
```
