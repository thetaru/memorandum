# システム情報
## ファームウェア
```
[ -d /sys/firmware/efi ] && echo "UEFI" || echo "BIOS"
```
## CPU
```
lscpu
```
## メモリ
```
lsmem
```
## ディスク
```
lsblk -f -o +MIN-IO,SIZE,STATE
```
## ディストリビューション
```
cat /etc/centos-release
```
## カーネルバージョン
```
uname -sr
```
