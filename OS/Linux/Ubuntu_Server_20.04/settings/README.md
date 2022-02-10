# Settings
## ■ ホスト名の設定
```
$ sudo hostnamectl set-hostname <hostname>
```

## ■ ブートローダーの設定
```
$ sudo vim /etc/default/grub
```
```
-  GRUB_CMDLINE_LINUX=""
+  GRUB_CMDLINE_LINUX="consoleblank=0 crashkernel=auto rhgb quiet ipv6.disable=1"
```
設定を反映します。
```
# BIOSの場合
$ sudo grub-mkconfig -o /boot/grub/grub.cfg

# UEFI
$ sudo grub-mkconfig -o /boot/efi/EFI/ubuntu/grub.cfg
```
再起動後、IPv6関連のカーネルモジュールがロードされていないことが確認できます。
```
$ lsmod | grep ipv6
```

## ■ ネットワークの設定
ネットワークの設定(IPアドレス、ルーティング、ゲートウェイ、DNSなど)は[netplan]()を参照してください。

## ■ 名前解決の設定
`/etc/resolv.conf`は使用しない
### /etc/hostsの設定
```
$ sudo vi /etc/hosts
```
```
# IPv6を使用しない場合はコメントアウトする
#::1     ip6-localhost ip6-loopback
#fe00::0 ip6-localnet
#ff00::0 ip6-mcastprefix
#ff02::1 ip6-allnodes
#ff02::2 ip6-allrouters
```

## ■ ロケールの設定
システムに設定されているロケールを確認します。
```
$ localectl
```
インストール済みロケールを確認します。
```
$ localectl list-locales
```
日本語ロケール(ja_JP.UTF-8)がインストールされていない場合、以下のコマンドでインストールします。
```
$ sudo apt install language-pack-ja
```
日本語ロケールを設定します。
```
$ sudo localectl set-locale LANG=ja_JP.UTF-8
```

## ■ タイムゾーンの設定
システムに設定されているタイムゾーンを確認します。
```
$ timedatectl
```
タイムゾーンの一覧を確認します。
```
$ timedatectl list-timezones
```
タイムゾーン(Asia/Tokyo)に設定します。
```
$ sudo timedatectl set-timezone Asia/Tokyo
```

## ■ 時刻同期の設定
ここでは、NTPクライアント(systemd-timesyncd.service)の設定のみを記載します。  
※ ntpdやchtonyを使うこともできますが、インストールが必要です  
  
NTPサービスが有効(active)になっていることを確認します。
```
$ timedatectl status
```
```
(snip)
NTP service:(inactive|active)
(snip)
```
NTPサービスが無効(inactive)の場合、次のコマンドで有効化します。
```
$ sudo timedatectl set-ntp true
```
参照先のNTPサーバを指定します。
```
$ sudo vim /etc/systemd/timesyncd.service
```
```
[Time]
NTP=<プライマリntpサーバ>
FallbackNTP=<セカンダリntpサーバ>
```
設定を有効化します。
```
$ sudo systemctl restart systemd-timesyncd
```
参照先NTPサーバと時刻同期できていることを確認します。
```
$ timedatectl timesync-status
```

## ■ パッケージリスト自動更新の設定
デフォルトでは、自動でパッケージリストを更新し、パッケージのアップグレードを行います。  
一連の処理は`/etc/apt/apt.conf.d/`配下のファイルに沿って実行されます。(実行順序は名前の昇順)  
  
自動パッケージリスト更新と自動パッケージアップグレードを無効にします。
```
$ sudo vim /etc/apt/apt.conf.d/20auto-upgrades
```
```
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
```
アップグレード対象となるパッケージをすべてコメントアウトし、アップグレードから除外するパッケージを指定します。
```
$ sudo vim /etc/apt/apt.conf.d/50unattended-upgrades
```
```
Unattended-Upgrade::Allowed-Origins {
//    "${distro_id}:${distro_codename}";
//    "${distro_id}:${distro_codename}-security";
//    "${distro_id}ESMApps:${distro_codename}-apps_security";
//    "${distro_id}ESM:${distro_codename}-infra-security";
//    "${distro_id}:${distro_codename}-updates";
//    "${distro_id}:${distro_codename}-proposed";
//    "${distro_id}:${distro_codename}-backports";
};

Unattended-Upgrade::Package-Blacklist {
    "linux-";
};
```

## ■ パッケージアップデート制限の設定
カーネルなどのパッケージがaptコマンドによってアップデートされないようにします。
```
# linux-から始まるパッケージをホールド対象とする
$ sudo apt-mark hold $(dpkg -l | grep "linux-" | sed -r 's/^.*(linux-[0-9a-z.-]*).*$/\1/')
```
ホールドしているパッケージ名を確認します。
```
$ apt-mark showhold
```

## ■ パッケージアップデート
パッケージリストをアップデートします。
```
$ sudo apt update
```
パッケージリストをもとにパッケージをアップグレードします。
```
$ sudo apt upgrade
```

## ■ 不要なサービスの停止
```
# パッケージ自動更新周りのサービスを無効化
$ sudo systemctl disable --now apt-daily.timer
$ sudo systemctl disable --now apt-daily.service
$ sudo systemctl disable --now apt-daily-upgrade.timer
$ sudo systemctl disable --now apt-daily-upgrade.service
$ sudo systemctl disable --now unattended-upgrades.service
```

## ■ sshdの設定

## ■ ufwの設定

## ■ apparmorの設定

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
$ sudo systemctl reboot
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

## ■ カーネルパラメータの設定
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
```
### 反映
# systemctl daemon-reexec
```
個々のサービスに対して設定するのなら`systemctl edit <サービス名>`より`DefaultLimitCORE`の設定値を変更します。
## ■ ログ設定
### journal設定
```
# vi /etc/systemd/journald.conf
```
#### 制限あり
```
### 30秒間に500以上のメッセージがあった場合ドロップ
-  #RateLimitIntervalSec=
+  RateLimitIntervalSec=30s
-  #RateLimitBurst=
+  RateLimitBurst=500
```
#### 制限なし
```
### 単位時間あたりに受付ける最大メッセージ数(0は無制限)
-  #RateLimitBurst=10000
+  RateLimitBurst=0
```
```
# systemctl restart systemd-journald
# systemctl status systemd-journald
```
### メッセージ溢れ回避
5秒間にrsyslogへ200以上のメッセージを送信するとメッセージを捨ててしまう。
```
# vi /etc/rsyslog.conf
```
#### 制限あり
```
### 10秒間に500以上のメッセージがあった場合ドロップ
-  module(load="imjournal" StateFile="imjournal.state")
+  module(load="imjournal" StateFile="imjournal.state" Ratelimit.Interval="10" Ratelimit.Burst="500")
```
#### 制限なし
```
### 無制限に書き込む
+  module(load="imjournal" StateFile="imjournal.state" Ratelimit.Interval="0")

-  module(load="imuxsock")
+  module(load="imuxsock" SysSock.Use="off" SysSock.RateLimit.Interval="0" SysSock.RateLimit.Burst="0")
```
```
# systemctl restart rsyslog.service
# systemctl status rsyslog.service
```
## ■ [任意]Proxyの設定
```
$ sudo vi /etc/profile.d/proxy.sh
```
```
#!/bin/bash
$PROXY="<Proxy-server Ip-address>:Port"
export proxy_http="http://$PROXY"
export proxy_https="https://$PROXY"

export no_proxy="127.0.0.1"
```
