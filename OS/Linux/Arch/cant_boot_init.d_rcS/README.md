# ブートが終わらない(can't run '/etc/init.d/rcS': No such file or directory)
ブート画面で以下のようなログが出力され続ける。
```
can't run '/etc/init.d/rcS': No such file or directory
can't open /dev/tty5: No such file or directory
process '-/bin/sh' (pid XXX) exited. Scheduling for restart.
...
```

## Live DVDで起動
イメージは[本家](https://manjaro.org/products/download/x86)からダウンロードしてDVDやUSBに焼く。  
Live DVD(USB)を使ってブートし、OSが起動したことを確認する。

## インターネット接続
有線でも無線でもお好みで。インターネットに出れて名前解決できればよい。

## arch-install-scriptsパッケージインストール
デフォルトでは`arch-chroot`コマンドが入ってなかったのでインストールする。
```sh
sudo pacman -S arch-install-scripts
```

## パーティションの確認
障害が起きているデバイスのパーティションを確認する。  
今回の環境では、`/`と`/dev/nvme0n1p4`、`/boot`と`/dev/nvme0n1p2`が対応している。
```sh
sudo lsblk -f
```

## パーティションのマウント
障害が起きているデバイスのパーティションをLive DVDから起動しているOSにマウントする。  
マウント先は`/mnt`と`/mnt/boot`とする。(後でchrootする)
```sh
sudo mkdir /mnt/boot
sudo mount /dev/nvme0n1p4 /mnt
sudo mount /dev/nvme0n1p2 /mnt/boot
``` 

## chroot
arch-chrootコマンドを使ってchrootする。  
chrootコマンドでもよいが`resolv.conf`などいい感じに設定してくれるので楽。
```sh
sudo arch-chroot /mnt
```

## initramfsの再生成
initramfsを再生成する。
```sh
mkinitcpio -p linux
```

## OSの再起動
OSを再起動し、正常に立ち上がることを確認する。
```sh
sudo systemctl reboot
```