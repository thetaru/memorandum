# パーティション設定
## ■ EBS追加
```
### filesystemを入れる
# mkfs.xfs -f /dev/xvdb
```
```
meta-data=/dev/xvdb              isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
```
## ■ 確認
```
# lsblk -o +UUID
```
```
# fdisk
```
```
### マウント用ディレクトリの作成
# mkdir -p /var/crash
```
```
### ファイルシステムのUUIDとディレクトリを紐づける
# vi /etc/fstab
```
