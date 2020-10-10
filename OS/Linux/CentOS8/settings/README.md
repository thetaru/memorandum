# Settings
## ■ ホスト名の設定
```
# hostnamectl set-hostname <hostname>
```
## ■ [Static]IPアドレス設定
認識しているデバイスを確認します
```
# nmcli device
```
```
DEVICE  TYPE      STATE     CONNECTION
ens192  ethernet  接続済み  ens192
ens224  ethernet  接続済み  ens224
lo      loopback  管理無し  --
```
<details>
<summary>STATEがdisconnectedだった場合</summary>
   
```
# nmcli connection add type ethernet con-name <CONNECTIONNAME> ifname <DEVICENAME>
```

</details>

`nmcli connection modify`を使って設定します(:warning: `/etc/sysconfig/network-script/ifcfg-ensxxx`に反映されます)  
`ensxxx`は環境に応じて置き換えて設定してください。
```
# nmcli connection modify ensxxx connection.autoconnect yes
# nmcli connection modify ensxxx ipv4.method manual ipv4.address <ip-address>/<prefix>
# nmcli connection modify ensxxx ipv4.gateway <gateway-address>
# nmcli connection modify ensxxx ipv4.dns "<dns1-address> <dns2-address>"
```
デバイスを再起動して設定を反映させます
```
# nmcli connection up ensxxx
```
```
接続が正常にアクティベートされました (D-Bus アクティブパス: /org/freedesktop/NetworkManager/ActiveConnection/3)
```
設定値を確認します
```
# nmcli device show ensxxx
```
<details>
<summary>[option]IPv6の無効化</summary>

```
# nmcli connection modify ensxxx ipv6.method ignore
```
```
# vi /etc/sysctl.d/70-ipv6.conf
```
```
+  net.ipv6.conf.all.disable_ipv6 = 1
+  net.ipv6.conf.default.disable_ipv6 = 1
```
設定を反映します
```
# sysctl --load /etc/sysctl.d/70-ipv6.conf
```
```
# systemctl reboot
```
IPv6が設定が無効化されていることを確認します
```
# nmcli device show ensxxx
```
```
GENERAL.DEVICE:                         ensxxx
GENERAL.TYPE:                           ethernet
GENERAL.HWADDR:                         aa:aa:aa:aa:aa:aa
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (接続済み)
GENERAL.CONNECTION:                     ensxxx
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/1
WIRED-PROPERTIES.CARRIER:               オン
IP4.ADDRESS[1]:                         <ip-address>/<prefix>
IP4.GATEWAY:                            <gateway-address>
IP4.ROUTE[1]:                           dst = xxx.xxx.xxx.xxx/yy, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                           dst = 0.0.0.0/0, nh = zzz.zzz.zzz.zzz, mt = 100
IP4.DNS[1]:                             <dns1-address>
IP6.GATEWAY:                            --
```
</details>

## ■ hostsの設定
```
# vi /etc/hosts
```
```
### IPv6は使わないので無効化
-  ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
+  #::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```
## ■ 不要なサービスの停止
調査中...
```
### いらないサービス(メモ)
bluetooth.service

# systemctl stop <service>
# systemctl disable <service>
```
## ■ カーネルアップデート抑止
```
# vi /etc/yum.conf
```
```
+  exclude=kernel* centos*
```
```
# vi /etc/dnf/dnf.conf
```
```
+  exclude=kernel* centos*
```
## ■ sshdの設定
```
# vi /etc/ssh/sshd_config
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
## ■ SELinuxの設定
```
# vi /etc/selinux/config
```
```
-  SELINUX=enforcing
+  SELINUX=disabled
```
## ■ firewalldの設定
```
### サービスのステータス確認
# systemctl status firewalld
```
1. **有効**にする場合(デフォルトで有効です)
```
### サービスの有効化
# systemctl start ufw

### 自動起動の無効化
# systemctl enable ufw
```
2. **無効**にする場合
```
### サービスの無効化
# systemctl stop ufw

### 自動起動の無効化
# systemctl disable ufw
```
ここでは、ufwの詳しい設定は行いません。
## ■ localeの設定
```
### 日本語用パッケージがインストールされていない場合はlanguage-pack-jaをインストール
# yum install langpacks-ja
```
```
### localeにja_JP.UTF-8を設定
# localectl set-locale LANG=ja_JP.utf8
```
```
### 確認
# localectl status
```
```
   System Locale: LANG=ja_JP.UTF-8
       VC Keymap: jp
      X11 Layout: jp
```
## ■ timezoneの設定
```
### タイムゾーンの変更
#  timedatectl set-timezone Asia/Tokyo
```
```
# timedatectl | grep "Time zone"
```
```
                Time zone: Asia/Tokyo (JST, +0900)
```
## ■ 時刻同期の設定
```
### chronyのインストール
# yum install chrony
```
```
# vi /etc/chrony.conf
```
```
### 参照先NTPサーバを指定
-  pool 2.centos.pool.ntp.org iburst
+  pool <ntp_server-address> iburst

### slewモードに設定
-  makestep 1.0 3
+  #makestep 1.0 3
+  leapsecmode slew

### うるう秒設定
+  maxslewrate 1000
```
```
### 同期状態の確認
# chronyc sources
```
```
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* <ntp-server>                1   6   377     9  +3649us[+5915us] +/-   30ms
```
```
### chronyサービスの起動
# systemctl start chrony
# systemctl enable chrony
```
## ■ pamの設定
`su` コマンドを実行できるユーザを制限します。  
:warning:例としてユーザ名は`thetaru`を使用しています。
```
### ユーザthetaru を グループwheelに追加
# usermod -aG wheel thetaru
```
```
### wheelグループに属していることを確認
# id thetaru
```
```
uid=1001(thetaru) gid=1001(thetaru) groups=1001(thetaru),1002(wheel)
```
```
# vi /etc/pam.d/su
```
```
### su可能ユーザ制限
-  #auth       required   pam_wheel.so
+  auth       required   pam_wheel.so use_uid
```
```
### 再起動して反映
# systemctl reboot
```
## ■ logrotateの設定
```
# vi /etc/logrotate.conf
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
# vi /etc/default/grub
```
```
-  GRUB_CMDLINE_LINUX="crashkernel=auto resume=UUID=03c2915c-7232-4e8b-8593-c553c429b2db rhgb quiet"
+  GRUB_CMDLINE_LINUX="crashkernel=auto resume=UUID=03c2915c-7232-4e8b-8593-c553c429b2db rhgb quiet consoleblank=0 ipv6.disable=1"
```
```
### BIOSの場合
# grub2-mkconfig -o /boot/grub2/grub.cfg
```
```
### UEFIの場合
# grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
```
## ■ カーネルパラメータの設定
https://gist.github.com/koudaiii/035120ed116ecf6f1b06  
https://note.com/ujisakura/n/n443807235887#o7Prw
```
# vi /etc/sysctl.conf
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
# systemctl -p
```
## ■ コアダンプ出力設定
```
# vi /etc/systemd/system.conf
```
```
-  #DefaultLimitCORE=
+  DefaultLimitCORE=infinity
```
個々のサービスに対して設定するのなら`systemctl edit <サービス名>`より`DefaultLimitCORE`の設定値を変更します。
## ■ ログ設定
### journal設定
```
# vi /etc/systemd/journald.conf
```
```
### 単位時間あたりに受付ける最大メッセージ数(0は無制限)
-  #RateLimitBurst=10000
+  RateLimitBurst=0
```
### メッセージ溢れ回避
5秒間にrsyslogへ200以上のメッセージを送信するとメッセージを捨ててしまう。
```
# vi /etc/rsyslog.conf
```
#### 制限あり
```
### 10秒間に500以上のメッセージがあった場合削除
+  $imjournalRatelimitInterval 10
+  $imjournalRatelimitBurst 500
```
#### 制限なし
```
### 無制限に書き込む
+  $imjournalRatelimitInterval 0
```
## ■ [option]Proxyの設定
```
# vi /etc/profile.d/proxy.sh
```
```
#!/bin/bash
PROXY="<Proxy-server Ip-address>:Port"
export proxy_http="http://$PROXY"
export proxy_https="http://$PROXY"
```
