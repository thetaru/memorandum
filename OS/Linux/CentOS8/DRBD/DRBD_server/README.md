# DRBDサーバの構築
## ■ 前提条件
以下の作業は`node-01`、`node-02`それぞれで実施します。  

|サーバ名|IPアドレス|同期ディスク|役割|
|:---|:---|:---|:---|
|node-01|192.168.137.1|/dev/sdb|プライマリ|
|node-02|192.168.137.2|/dev/sdb|セカンダリ|

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
以下に出ているデバイス`/dev/drbd1`はDRBDデバイスのことを指し、DRBDリソースの有効化時に作成されます。
```
# vi /etc/drbd.d/r0.res
```
```
resource r0 {
  on node-01 {
    device    /dev/drbd1;
    disk      /dev/mapper/drbdpool-drbdata;
    address   192.168.137.30:7789;
    meta-disk internal;
  }
  on node-02 {
    device    /dev/drbd1;
    disk      /dev/mapper/drbdpool-drbdata;
    address   192.168.137.31:7789;
    meta-disk internal;
  }
}
```
※ `/etc/drbd.conf`が`/etc/drbd.d/r0.res`をインクルードします

### DRBDリソースの初期化
```
### リソースr0にメタデータを作成
# drbdadm create-md r0
```

### DRBDリソースの有効化
リソースを有効化にした後にデバイスを確認すると`/dev/drbd1`が作成されていることがわかります。
```
### リソースr0を有効化
# drbdadm up r0
```

### DRBD同期
#### プライマリ(node-01)の指定
```
[root@node-01 ~]# drbdadm primary --force r0
[root@node-01 ~]# drbdadm status
```
#### セカンダリ(node-02)の指定
```
[root@node-02 ~]# drbdadm secondary r0
[root@node-02 ~]# drbdadm status
```
#### 同期完了の確認
プライマリ・セカンダリを設定後、同期が開始され少し待つと完了します。
```
[root@node-01 ~]# drbdadm status
```
```
r0 role:Primary
  disk:UpToDate
  node-02 role:Secondary
    peer-disk:UpToDate
```
```
[root@node-02 ~]# drbdadm status
```
```
r0 role:Secondary
  disk:UpToDate
  node-01 role:Primary
    peer-disk:UpToDate
```

### DRBDデバイスにファイルシステムを作成
セカンダリはプライマリと同期しているため、プライマリ側でファイルシステムを作成すれば十分です。 
```
[root@node-01 ~]# mkfs.xfs /dev/drbd1
```

## ■ 設定の反映
## ■ 設定の確認
## ■ 負荷テスト項目
## ■ 監視項目
