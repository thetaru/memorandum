# DRBDサーバの構築
## ■ 前提条件
以下の作業は`node-01`、`node-02`それぞれで実施します。
|サーバ名|IPアドレス|同期ディスク|
|:---|:---|:---|
|node-01|192.168.137.1|/dev/sdb|
|node-02|192.168.137.2|/dev/sdb|

## ■ 事前準備
### パーティションの作成
デバイス`/dev/sdb`をまるごと1つのパーティション`/dev/sdb1`にします。
```
# parted -s -a optimal -- /dev/sdb mklabel gpt
# parted -s -a optimal -- /dev/sdb mkpart primary 0% 100%
# parted -s -- /dev/sdb align-check optimal 1
```
### PV・VG・LVの作成
```
# pvcreate /dev/sdb1
# vgcreate drbdpool /dev/sdb1
# lvcreate -n drbdata -l 100% FREE drbdpool
```

## ■ インストール
### elrepoレポジトリの登録
```
# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
# yum install https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
```
### DRBDパッケージのインストール
```
# yum search drbd
# yum install drbd90-utils kmod-drbd90
```
## ■ バージョンの確認
## ■ サービスの起動
一通りの設定が完了するまでサービスを起動させないでください。
## ■ 関連サービス
|サービス名|ポート番号|役割|
|:---|:---|:---|
|drbd|6996-7800/tcp||

## ■ 主設定ファイル /etc/drbd.conf
### ● xxxセクション
### ● yyyディレクティブ
- aaa(recommended)
- bbb
### ● zzzパラメータ
### ● 設定例
### ● 文法チェック
## ■ 設定ファイル yyy
## ■ セキュリティ
### ● firewall
### ● 証明書
### ● 認証
## ■ ロギング
### ● rsyslog
### ● logrotate
## ■ 設定の反映
## ■ 設定の確認
## ■ 負荷テスト項目
## ■ 監視項目
