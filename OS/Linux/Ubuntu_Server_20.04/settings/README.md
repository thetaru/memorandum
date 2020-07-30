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
### IPアドレスを反映
$ sudo netplan apply
```
```
### 反映されていることを確認
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
:warning:手動でカーネルアップデートをするとバージョンが上がることに注意します。
## sshdの設定
## ufwの設定
```
### サービスのステータス確認
$ systemctl status ufw
```
■ 有効にする場合(デフォルトで有効です)
```
### サービスの有効化
$ sudo systemctl start ufw

### 自動起動の無効化
$ sudo systemctl enable ufw
```
■ 無効にする場合
```
### サービスの無効化
$ sudo systemctl stop ufw

### 自動起動の無効化
$ sudo systemctl disable ufw
```
ここでは、ufwの詳しい設定は行いません。
## localeの設定
```
### language-pack-jaのインストール
$ sudo apt-get install language-pack-ja
```
```
### localeにja_JP.UTF-8を設定
$ sudo update-locale LANG=ja_JP.UTF-8
```
```
### 確認
$ cat /etc/default/locale
```
```
LANG=ja_JP.UTF-8
```
## 時刻同期の設定
```
### ntpのインストール
$ sudo apt-get install ntp
```
