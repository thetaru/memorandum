# XFSファイルシステムのシステムバックアップとリストア
以下の方法でLVMは対応していないので注意してください。
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

ここでは例として以下のようになっていると仮定して進めます。
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

### 各デバイスごとに取得すること
# fdisk -l /dev/sdX > /backup/fdisk_sdX.log
```

## バックアップ
### EFIシステムパーティション`/boot/efi`
```
# sync
# tar -C /boot/efi -cf /backup/sda2.tar .
```
### xfsパーティション
```
# xfsdump -l 0 -e - /boot 2>> /tmp/backup.log | gzip -c > /backup/sda1.dump.gz
# xfsdump -l 0 -e - / 2>> /tmp/backup.log | gzip -c > /backup/sda3.dump.gz
```
## リストア
### レスキューモードに入る
インストールメディアからブートし  
`TroubleShooting -> Rescue a CentOS Linux system -> 1) Continue`  
の順番に遷移します。  
すると従来のファイルシステムが`/mnt/sysimage`以下にマウントされます。  
IPを設定します。
```
### 必要に応じてGWも設定します
# nmcli connection modify ens192 ipv4.method manual ipv4.addresses 192.168.137.2/24
```
バックアップを置いたNFSサーバにマウントします。
```
# mkdir /backup
# mount -t nfs 192.168.137.1:/vol /backup
```
### [Option]ディスクを交換する場合

<details>
<summary>[Option]ディスクを交換する場合</summary>

### ディスクのパーティションを定義
既存のパーティションをもとに設定していきます。
```
# parted /dev/sdb
(parted) mklabel gpt
(parted) unit MiB
(parted) mkpart
Partition type? : (primary|extended)
File system : (xfs|linux-swap|vfat)
Start : 開始位置の指定
End   : 終了位置の指定
(parted) q
```
### ブートフラグを立てる
```
### 「１」はパーティション番号です。pの結果からブートフラグを立てるパーティションを指定します。
# parted /dev/sdb
(parted) p
(parted) set 1 boot on
```
### fstabの編集
以下の結果をもとに`/etc/fstab`を編集します。  
```
# lsblk -f
```
```
# vi /etc/fstab
```
### ブート設定準備
`dev`, `proc`, `sys`をchroot先のディレクトリ(`/mnt/sysimage`)にマウントします。
```
# mount -t proc proc /mnt/sysimage/proc
# mount --bind /dev  /mnt/sysimage/dev
# mount -t sysfs sysfs /mnt/sysimage/sys
```
リストア先にchrootします。
```
# chroot /mnt/sysimage
```
### UEFIブート設定
ディスクを交換した場合はUUIDが変更するので、UEFIブートの設定を変更します。
```
### 現在の起動順序の確認
# efibootmgr -v
```
```
BootCurrent: 0000
Timeout: 1 seconds
BootOrder: 0000,0001
Boot0000* CentOS        HD(1,800,64000,7e44aa01-f593-4ce4-8ec8-b3afba558cfc)File(\EFI\CENTOS\SHIM.EFI)
Boot0001* UEFI OS       HD(1,800,64000,7e44aa01-f593-4ce4-8ec8-b3afba558cfc)File(\EFI\BOOT\BOOTX64.EFI)
```
既存設定を削除します。
```
# efibootmgr -b 1 -B
# efibootmgr -b 0 -B
```
起動順序を登録します。
```
# efibootmgr -c -d /dev/sdb -p 1 -l '\EFI\CENTOS\SHIM.EFI' -L 'CentOS'
# efibootmgr -o 0000
# efibootmgr -t 1
```
### grub2ブート設定ファイルの再作成
`/boot/efi/EFI/CENTOS/grub.cfg`に古いパーティションへのUUIDが使用されているので再作成して修正します。
```
# grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
```
### 初期RAMディスク再作成
古いパーティションのUUIDを見ているので古いディスクを探しに行ってしまうため再作成して修正します。
```
# cd /boot
# ls vmlinuz-*
# ls initramfs-*
# mv initramfs-<version>.img initramfs-<version>.img.old
# dracut -f initramfs-<version>.img <version>
```
### ディスク同期
キャッシュに残っているファイル変更内容を書き込みます。これを忘れるとブートできません。
```
# sync
```
### chrootの終了
```
# exit
```
ここでディスクを交換する場合は終了です。

</details>

### データリストア
```
### /bootの場合
# cd /mnt/sysimage/boot
# gzip -dc /backup/sda1.dump.gz | xfsrestore - ./
# sync
```
```
### /の場合
# cd /mnt/sysimage
# gzip -dc /backup/sda3.dump.gz | xfsrestore - ./
# sync
```
```
### /boot/efiの場合
# cd /mnt/sysimage
# tar xf /backup/sda2.tar
# sync
```
UEFI環境の場合、ブートローダは`/boot/efi`以下に存在するため`grub2-install`は不要です。
