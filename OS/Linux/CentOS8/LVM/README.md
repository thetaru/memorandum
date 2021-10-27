# LVM
## ■ 機能の概要
1. DiskからPVを作成する
```
Disk(/dev/sdb,/dev/sdc)のブロックデバイス(/dev/sdb1,/dev/sdb2,...,/dev/sdc1,/dev/sdc2,...)をPVとして管理する
```
2. PVをまとめVGを作成する
```
PV(/dev/sdb1,/dev/sdb2,...,/dev/sdc1,/dev/sdc2,...)からVG(VolumeGroup00)を作成する
```
3. VGを分割しLVを作成する
```
VG(VolumeGroup00)を分割しLV(/dev/VolumeGroup00/LogicalVolume00,/dev/VolumeGroup00/LogicalVolume01,...)を作成する
```
4. LVを
```
Disk(HDD,SSD) -> PV(Physical Volume) -> VG(Volume Group) -> LV(Logical Volume) -> Partition
```

複数のディスク(の一部または全体)をまとめることで、柔軟なシステム構成をすることが可能になります。  
(制限はあるものの)動的にシステム変更(縮小・拡張等)ができるのも強みです。
## ■
## ■
