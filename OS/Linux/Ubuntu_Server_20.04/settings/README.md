# Settings
## ■ ホスト名の設定
```
$ sudo hostnamectl set-hostname <hostname>
```
## ■ [Static]IPアドレス設定
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
## ■ hostsの設定
```
$ sudo vi /etc/hosts
```
```
### IPv6は使わないので無効化
-  ::1     ip6-localhost ip6-loopback
+  #::1     ip6-localhost ip6-loopback

-  fe00::0 ip6-localnet
+  #fe00::0 ip6-localnet

-  ff00::0 ip6-mcastprefix
+  #ff00::0 ip6-mcastprefix

-  ff02::1 ip6-allnodes
+  #ff02::1 ip6-allnodes

-  ff02::2 ip6-allrouters
+  #ff02::2 ip6-allrouters
```
## ■ パッケージアップデート
```
$ sudo apt-get update
```
## ■ カーネルアップデート抑止
```
$ sudo apt-mark hold linux-image-generic linux-headers-generic
```
:warning:手動でカーネルアップデートをするとバージョンが上がることに注意します。
## ■ sshdの設定
```
$ sudo vi /etc/ssh/sshd_config
```
```
### sshで使用するポートを指定
-  #Port 22
+  Port 22
```
```
### IPv4のみ許可
-  #AddressFamily any
+  AddressFamily inet
```
```
### rootでのログインを禁止
-  PermitRootLogin prohibit-password
+  PermitRootLogin no
```
```
### パスワード認証を禁止
-  PasswordAuthentication yes
+  PasswordAuthentication no
```
```
### sshdを再起動
$ sudo systemctl restart sshd
```
## ■ ufwの設定
```
### サービスのステータス確認
$ systemctl status ufw
```
1. 有効にする場合(デフォルトで有効です)
```
### サービスの有効化
$ sudo systemctl start ufw

### 自動起動の無効化
$ sudo systemctl enable ufw
```
2. 無効にする場合
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
## ■ timezoneの設定
```
### Asia/Tokyoのシンボリックリンクlocaltimeを作成
$ sudo ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```
```
$ ll /etc/localtime
```
```
lrwxrwxrwx 1 root root 30  7月 31 22:27 /etc/localtime -> /usr/share/zoneinfo/Asia/Tokyo
```
## ■ 時刻同期の設定
```
### ntpのインストール
$ sudo apt-get install ntp
```
```
$ sudo vi /etc/ntp.conf
```
```
-  pool 0.ubuntu.pool.ntp.org iburst
+  #pool 0.ubuntu.pool.ntp.org iburst

-  pool 1.ubuntu.pool.ntp.org iburst
+  #pool 1.ubuntu.pool.ntp.org iburst

-  pool 2.ubuntu.pool.ntp.org iburst
+  #pool 2.ubuntu.pool.ntp.org iburst

-  pool 3.ubuntu.pool.ntp.org iburst
+  #pool 3.ubuntu.pool.ntp.org iburst
```
```
### 参照するntpサーバを指定
+  server <ntp-server1 ip-address or hostname>
+  server <ntp-server2 ip-address or hostname>
+  server <ntp-server3 ip-address or hostname>
```
```
-  pool ntp.ubuntu.com
+  #pool ntp.ubuntu.com
```
```
### IPv6は使わないので無効化
-  restrict -6 default kod notrap nomodify nopeer noquery limited
+  #restrict -6 default kod notrap nomodify nopeer noquery limited
```
```
### IPv6は使わないので無効化
-  restrict ::1
+  #restrict ::1
```
```
### ntpサービスの起動
$ sudo systemctl start ntp.service
```
## ■ pamの設定
`su` コマンドを実行できるユーザを制限します。  
:warning:ユーザ名として`thetaru`を使用しています。
```
### ubuntuにはwheelグループがデフォルトで存在しないので作成
$ sudo addgroup wheel
```
```
### ユーザthetaru を グループwheelに追加
$ sudo usermod -aG wheel thetaru
```
```
### wheelグループに属していることを確認
$ id thetaru
```
```
uid=1001(thetaru) gid=1001(thetaru) groups=1001(thetaru),1002(wheel)
```
```
$ sudo vi /etc/pam.d/su
```
```
### su可能ユーザ制限
-  #auth       required   pam_wheel.so
+  auth       required   pam_wheel.so use_uid
```
```
### 再起動して反映
$ reboot
```
## ■ logrotateの設定
```
$ sudo vi /etc/logrotate.conf
```
```
### ローテート期間
-  weekly
+  daily
```
```
### 7世代分のログを管理
-  rotate 4
+  rotate 7
```
```
### ローテーションしたログをgzipで圧縮
-  #compress
+  compress
```
## ■ 不要なサービスの停止
調査中...
```
### パッケージリストの自動更新の停止・自動起動の無効化
$ sudo systemctl mask apt-daily.timer
$ sudo systemctl mask apt-daily.service
$ sudo systemctl mask apt-daily-upgrade.timer
$ sudo systemctl mask apt-daily-upgrade.service
```
# 書きたいこと
```
## カーネルパラメータの設定!!!!!!
/etc/sysctl.conf
```
```
### コアダンプ設定(コアファイル出力先設定)
kernel.core_pattern=/var/tmp/core-%e.%p

### コアダンプ設定(rootのみ読み取り許可)
fs.suid_dumpable=2

### OOM Killer設定(OOM発生時の挙動設定)
vm.panic_on_oom=2
```
```
/etc/systemd/system.conf
### コアダンプ設定(コアファイルの最大値)
[Manager]
DefaultLimitCORE=infinity
```
```
/etc/sysconfig/init]
### コアダンプ設定(コアファイルの出力設定)
DAEMON_COREFILE_LIMIT=unlimited

/etc/rsyslog.conf
### journalログ抑止対策
$imjournalRatelimitInterval 0
$SystemLogRateLimitInterval 0
## proxy設定
```
