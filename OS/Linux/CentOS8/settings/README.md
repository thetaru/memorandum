# Settings
## ■ ホスト名の設定
```
# hostnamectl set-hostname <hostname>
```
## ■ [Static]IPアドレス設定
認識しているデバイスを確認します
```
# nmcli dev
```
```
DEVICE  TYPE      STATE     CONNECTION
ens192  ethernet  接続済み  ens192
ens224  ethernet  接続済み  ens224
lo      loopback  管理無し  --
```
`nmcli connection modify`を使って設定します(:warning: `/etc/sysconfig/network-script/ifcfg-ensxxx`に反映されます)  
`ensxxx`は環境に応じて置き換えて設定してください。
```
# nmcli connection modify ensxxx ipv4.method manual
# nmcli connection modify ensxxx connection.autoconnect <yes|no>
# nmcli connection modify ensxxx ipv4.address <ip-address>/<prefix>
# nmcli connection modify ensxxx ipv4.gateway <gateway-address>
# nmcli connection modify ensxxx ipv4.dns "<dns1-address> <dns2-address>"
```
[option]IPv6の設定を無効化します
```
# nmcli connection modify ensxxx ipv6.method ignore
# nmcli connection modify ensxxx
```
デバイスを再起動して設定を反映させます
```
# nmcli connection up ensxxx
```
設定値を確認します
```
# nmcli dev ensxxx
```
```
接続が正常にアクティベートされました (D-Bus アクティブパス: /org/freedesktop/NetworkManager/ActiveConnection/3)
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
### いらないサービス(メモ)
avahi-daemon.service
bluetooth.service
cups.service
cups-browsed.service
ModemManager.service

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
## ■ firewalldの設定
```
### サービスのステータス確認
$ systemctl status firewalld
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
:warning:例としてユーザ名は`thetaru`を使用しています。
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
## ■ カーネルクラッシュダンプ
```
### kdumpのインストール
$ sudo apt install linux-crashdump
```
```
$ kdump-config show
```
```
DUMP_MODE:        kdump
USE_KDUMP:        1
KDUMP_SYSCTL:     kernel.panic_on_oops=1
KDUMP_COREDIR:    /var/crash
crashkernel addr: 
   /var/lib/kdump/vmlinuz: symbolic link to /boot/vmlinuz-5.4.0-45-generic
kdump initrd: 
   /var/lib/kdump/initrd.img: symbolic link to /var/lib/kdump/initrd.img-5.4.0-45-generic
current state:    Not ready to kdump
```
`/etc/default/kdump-tools`の`KDUMP_COREDIR`からコアダンプ出力先を変更できます。
## ■ コアダンプ出力設定
```
$ sudo vi /etc/systemd/system.conf
```
```
-  #DefaultLimitCORE=
+  DefaultLimitCORE=infinity
```
個々のサービスに対して設定するのなら`systemctl edit <サービス名>`より`DefaultLimitCORE`の設定値を変更します。
## ■ [option]Proxyの設定
```
$ sudo vi /etc/profile.d/proxy.sh
```
```
#!/bin/bash
PROXY="<Proxy-server Ip-address>:Port"
export proxy_http="http://$PROXY"
export proxy_https="http://$PROXY"
```
# 書きたいこと
```
/etc/rsyslog.conf
### journalログ溢れ対策
$imjournalRatelimitInterval 0
$SystemLogRateLimitInterval 0
```
