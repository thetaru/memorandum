# chroot
grubが壊れたり、レスキューモードに入った際に使用します。
## ■ 事前作業
ホストの元々ある環境をchrootの環境に持って行きます。  
`mount --bind`としているのはすでにマウントされているデバイスのディレクトリを別のディレクトリにマウントさせたいからです。  
```
# for i in dev dev/pts proc sys; do mount --bind /$i /mnt/$i; done
```
```
# chroot /mnt
```
```
### (任意) ホストの元々ある環境にするためにマウントする
# mount /dev/sdaX /
(環境依存のため省略)
```
あとは`/boot`マウントするなり`grub2-install`するなり`grub2-mkconfig`するなりしてください。
