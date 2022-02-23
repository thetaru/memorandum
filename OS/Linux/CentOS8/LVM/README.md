# LVM
## ■ 機能の概要
1. DiskからPVを作成する
```
Disk(/dev/sdb,/dev/sdc)のブロックデバイス(/dev/sdb1,/dev/sdb2,...,/dev/sdc1,/dev/sdc2,...)をPVとして管理する
```
2. PVをまとめVGを作成する
```
PV(/dev/sdb1,/dev/sdb2,...,/dev/sdc1,/dev/sdc2,...)からVG(VG0)を作成する
```
3. VGを分割しLVを作成する
```
VG(VG0)を分割しLV(/dev/VG0/LV0,/dev/VG0/LV1,...)を作成する
```

大まかな流れは以下の通りです。
```
Disk(HDD,SSD) -> PV(Physical Volume) -> VG(Volume Group) -> LV(Logical Volume)
```

複数のディスク(の一部または全体)をまとめることで、柔軟なシステム構成をすることが可能になります。  
(制限はあるものの)動的にシステム変更(縮小・拡張等)ができるのも強みです。
## ■ 設定用コマンド
### PV 作成/削除
### VG 作成/削除
### LV 作成/削除
## ■ 確認用コマンド
### PV
```
# pvdisplay
```
### VG
```
# vgdisplay
```
### LV
```
# lvdisplay
```
