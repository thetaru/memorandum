# XFSファイルシステムのシステムバックアップとリストア
## 前提条件
- ファイルシステムに**xfs**を使用していること
- ブートローダに**UEFI**を使用していること(これは必須の条件ではない)
- バックアップ先があること(NFSサーバが好ましい)
- xfsdump/xfsresoreコマンドが実行できること
- grub2-mkconfig/efibootmgrコマンドが実行できること
- インストールメディアがあること(レスキューモードに入るために使用)

|バックアップ先|内容|
|:---|:---|
|マウント先|192.168.137.1:/vol|
|マウントポイント|/backup|
|プロトコル|NFS|
|バージョン|3以上|

|デバイス名|FS TYPE|MOUNT POINT|
|:---|:---|:---|
|/dev/sda1|xfs|/boot|
|/dev/sda2|vfat|/boot/efi|
|/dev/sda3|xfs|/|

### 事前準備
まずNFSサーバにマウントします。
```
# mount -t nfs 192.168.137.1:/vol /backup
```
バックアップ前にデバイス(/dev/sdX)の情報を抜き取ります。
```
### EFI情報
# efibootmgr -v > /backup/efibootmgr.log

### fstab
# cp -p /etc/fstab /backup/fstab.org

### UUID対応
# lsblk -f > /backup/lsblk.log

### 
# fdisk -l /dev/sdX > /backup/fdisk_sdX.log
```
lvmを使っている場合は以下も実施します。
```
# pvdisplay > /backup/lv.log
# vgdisplay > /backup/vg.log
# lvdisplay > /backup/vp.log
```
## バックアップ
### EFIシステムパーティション`/boot/efi`
```
# sync
# tar -C /boot/efi -cf /backup/boot_efi.tar .
```
### xfsパーティション
```
# xfsdump -l 0 -e - <デバイス名> 2>> /tmp/backup.log | gzip -c > /backup/<デバイス名>.dump.gz
```
#### 例
```
# xfsdump -l 0 -e - /boot 2>> /tmp/backup.log | gzip -c > /backup/boot.dump.gz
# xfsdump -l 0 -e - / 2>> /tmp/backup.log | gzip -c > /backup/root.dump.gz
```
## リストア
### レスキューモードに入る
インストールメディアからブートし`TroubleShooting -> Rescue a CentOS Linux system -> 1) Continue`の順番に遷移します。  
すると従来のファイルシステムが`/mnt/sysimage`以下にマウントされます。  
次にIPを設定します。
```
### 必要に応じてGWも設定します
# nmcli connection modify ens192 ipv4.method manual ipv4.addresses 192.168.137.2/24
```
バックアップを置いたNFSサーバにマウント
```
# mkdir /backup
# mount -t nfs 192.168.137.1:/vol /backup
```
### データリストア
```
cd /mnt/sysimage/<従来のマウントポイント>
zcat /backup/<デバイス名>.dump.gz | xfsrestore - /boot
```
