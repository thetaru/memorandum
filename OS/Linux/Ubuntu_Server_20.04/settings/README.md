# Settings
## ■ ホスト名の設定
```
$ sudo hostnamectl set-hostname <hostname>
```
## ■ [Static]IPアドレス設定
インストール時に作成される`/etc/netplan/00-installer-config.yaml`は無効化します。  
yamlファイルでなければ設定は読み込まれません。
```
# sudo mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.org
```
`/etc/netplan/99_config.yaml`を作成し、下記のように記述します。  
詳しい設定方法に関しては[ここ](https://www.komee.org/entry/2018/06/12/181400)が参考になります。
```
$ sudo vi /etc/netplan/99_config.yaml
```
```
network:
  version: 2
  renderer: networkd
  ethernets:
    <NIC_Name>:
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
$ sudo apt-get upgrade
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
## ■ カーネルアップデート抑止
```
$ sudo apt-mark hold linux-image-generic linux-headers-generic
```
:warning:`sudo apt full-upgrade`でアップデートをするとカーネルアップデートが実行してしまうことに注意します。
## ■ sshdの設定
```
$ sudo vi /etc/ssh/sshd_config
```
```
### sshで使用するポートを指定
-  #Port 22
+  Port 2020

### IPv4のみ許可
-  #AddressFamily any
+  AddressFamily inet

### rootでのログインを禁止
-  PermitRootLogin prohibit-password
+  PermitRootLogin no

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
1. **有効**にする場合(デフォルトで有効です)
```
### サービスの有効化
$ sudo systemctl start ufw

### 自動起動の無効化
$ sudo systemctl enable ufw
```
2. **無効**にする場合
```
### サービスの無効化
$ sudo systemctl stop ufw

### 自動起動の無効化
$ sudo systemctl disable ufw
```
ここでは、ufwの詳しい設定は行いません。
## ■ localeの設定
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
### ntpdの設定
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

### 参照するntpサーバを指定
+  server <ntp-server1 ip-address or hostname>
+  server <ntp-server2 ip-address or hostname>
+  server <ntp-server3 ip-address or hostname>

-  pool ntp.ubuntu.com
+  #pool ntp.ubuntu.com

### IPv6は使わないので無効化
-  restrict -6 default kod notrap nomodify nopeer noquery limited
+  #restrict -6 default kod notrap nomodify nopeer noquery limited

### IPv6は使わないので無効化
-  restrict ::1
+  #restrict ::1
```
```
### step動作抑止
$ sudo vi /etc/default/ntp
```
```
-  NTPD_OPTS='-g'
+  NTPD_OPTS='-g -x'
```
### ntpdateの設定
```
### ntpdが起動する前に時刻同期をするため
$ sudo vi /etc/ntp/step-tickers
```
```
+  <ntp-server ip-address or hostname>
```
### ntpdate, ntpdの起動
ntpdateを起動してからntpdを起動しましょう。
```
### ntpdateの起動
$ sudo systemctl start ntpdate

### ntpサービスの起動
$ sudo systemctl start ntpd
$ sudo systemctl enable ntpd
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

### 7世代分のログを管理
-  rotate 4
+  rotate 7

### ローテーションしたログをgzipで圧縮
-  #compress
+  compress
```
## ■ ブートローダーの設定(GRUB2)
```
$ sudo vi /etc/default/grub
```
```
-  GRUB_CMDLINE_LINUX=""
+  GRUB_CMDLINE_LINUX="consoleblank=0 crashkernel=auto rhgb quiet"
```
```
$ sudo update-grub
```
## ■ カーネルパラメータの設定
https://gist.github.com/koudaiii/035120ed116ecf6f1b06  
https://note.com/ujisakura/n/n443807235887#o7Prw
```
$ sudo vi /etc/sysctl.conf
```
```
###
+  kernel.core_pattern=/var/tmp/core-%e.%p

###
+  fs.suid_dumpable=2

### OOM Killer が実行に必ずカーネルパニックさせる
+  vm.panic_on_oom=2
```
```
### 設定の反映
$ sudo systemctl -p
```
## ■ コアダンプ出力設定
```
$ sudo vi /etc/systemd/system.conf
```
```
-  #DefaultLimitCORE=
+  DefaultLimitCORE=infinity
```
個々のサービスに対して設定するのなら`systemctl edit <サービス名>`より`DefaultLimitCORE`の設定値を変更します。
## ■ Proxyの設定
```
$ sudo vi /etc/profile.d/proxy.sh
```
```
#!/bin/bash
$PROXY="<Proxy-server Ip-address>:Port"
export proxy_http=
export proxy_https=
```
# 書きたいこと(ubuntuでも必要か検証すること
```
/etc/rsyslog.conf
### journalログ溢れ対策
$imjournalRatelimitInterval 0
$SystemLogRateLimitInterval 0
```
