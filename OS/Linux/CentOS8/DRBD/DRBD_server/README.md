# DRBDサーバの構築
## ■ 前提条件
以下の作業は`node-01`、`node-02`それぞれで実施します。
|サーバ名|IPアドレス|同期ディスク|
|:---|:---|:---|
|node-01|192.168.137.1|/dev/sdb|
|node-02|192.168.137.2|/dev/sdb|

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

## ■ DRBDデバイスの作成
### パーティションの作成
デバイス`/dev/sdb`をまるごと1つのパーティション`/dev/sdb1`にします。
```
# parted /dev/sdb mklabel gpt
# parted /dev/sdb mkpart primary 0% 100%
# parted /dev/sdb set 1 lvm on
```
### PV・VG・LVの作成
```
# pvcreate /dev/sdb1
# vgcreate drbdpool /dev/sdb1
# lvcreate -n drbdata -l100%FREE drbdpool
```
### DRBDリソースの定義
リソースにノード間で同期させるLVをそれぞれ記述します。
```
# vi /etc/drbd.d/r0.res
```
```
resource r0 {
  on node1 {
    device    /dev/drbdpool;
    disk      /dev/mapper/drbdpool-drbdata;
    address   192.168.137.30:7789;
    meta-disk internal;
  }
  on node2 {
    device    /dev/drbdpool;
    disk      /dev/mapper/drbdpool-drbdata;
    address   192.168.137.31:7789;
    meta-disk internal;
  }
}
```
※ `/etc/drbd.conf`が`/etc/drbd.d/r0.res`をインクルードします

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
