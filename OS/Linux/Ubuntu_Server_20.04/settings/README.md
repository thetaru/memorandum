# settings
## ホスト名の設定
```
$ sudo hostnamectl set-hostname <hostname>
```
## (Static)IPアドレス設定
`/etc/netplan/99_config.yaml`を作成し、下記のように記述します。
```
$ sudo vi /etc/netplan/99_config.yaml
```
```
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: false
      dhcp6: false
      addresses:
        - <host ip-address>/<prefix>
      gateway4: <default-gateway ip-address>
      nameservers:
        addresses: [<dns-server ip-address1>, <dns-server ip-address2>]
```
```
### IPアドレスを反映します
$ sudo netplan apply
```
```
### 反映されていることを確認します
$ ip a
```
```
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:d9:61:04 brd ff:ff:ff:ff:ff:ff
    inet 192.168.137.3/24 brd 192.168.137.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fed9:6104/64 scope link
       valid_lft forever preferred_lft forever
```
## パッケージアップデート
```
$ sudo apt-get update
```
## カーネルアップデート抑止
```
$ sudo apt-mark hold linux-image-generic linux-headers-generic
```
### 試しに違うバージョンのカーネルを入れてみます
```
$ uname -r
```
```
5.4.0-26-generic
```
```
$ sudo apt-get install linux-image-5.6.0-1020-oem
```
```
...
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.6.0-1020-oem
Found initrd image: /boot/initrd.img-5.6.0-1020-oem
Found linux image: /boot/vmlinuz-5.4.0-26-generic
Found initrd image: /boot/initrd.img-5.4.0-26-generic
done
```
```
### アップデートされていません
$ uname -r
```
```
5.4.0-26-generic
```
