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

## ■ カーネルパラメータの設定
```
$ sudo vim /etc/sysctl.conf
```
```
fs.suid_dumpable=2
net.ipv4.tcp_timestamps=0
vm.panic_on_oom=2
```
設定を反映します。
```
$ sudo systemctl -p
```
## ■ ネットワークの設定
ネットワークの設定(IPアドレス、ルーティング、ゲートウェイ、DNSなど)は[systemd-networkd]()を参照してください。

## ■ [任意] プロキシの設定
```
$ sudo vim /etc/profile.d/proxy.sh
```
```
PROXY="http://[<ユーザ名>:<パスワード>@]<プロキシのIPアドレスまたはホスト名>:<ポート番号>"
export http_proxy=$PROXY
export HTTP_PROXY=$PROXY
export https_proxy=$PROXY
export HTTPS_PROXY=$PROXY
export no_proxy="127.0.0.1"
```

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
$ localectl status
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
設定が反映されていることを確認します。
```
$ localectl status
```

## ■ タイムゾーンの設定
システムに設定されているタイムゾーンを確認します。  
すでに指定のタイムゾーン(ここでは、Asia/Tokyo)になっている場合、タイムゾーンの設定は不要です。
```
$ timedatectl status
```
タイムゾーン(Asia/Tokyo)に設定します。
```
$ sudo timedatectl set-timezone Asia/Tokyo
```
設定が反映されていることを確認します。
```
$ timedatectl status
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

## ■ カーネルダンプの設定
OSがクラッシュした際に、カーネルが使用していたメモリ上の内容をファイルに出力します。
```
$ sudo apt install linux-crashdump
```
```
$ kdump-config show
```
`/etc/default/kdump-tools`の`KDUMP_COREDIR`からコアダンプ出力先を変更できます。

## ■ コアダンプの設定
ソフトウェア(OSを含む)がクラッシュした際に、そのソフトウェアが使用していたメモリ上の内容をファイルに出力します。  
コアダンプの出力をするかしないかはプロジェクトのポリシーにも依存します。(メモリ情報に機密情報を含む場合があるため)  
  
`apport.service`が有効であることを確認します。(デフォルトで有効(enable)のはず)
```
$ systemctl status apport.service
```
apport機能が有効になっていることを確認します。(デフォルトで有効(enable=1)のはず)
```
$ sudo vim /etc/default/apoort
```
```
enabled=1
```
コアファイルのサイズの最大値を無制限に変更します。
```
$ sudo vim /etc/systemd/system.conf
```
```
-  #DefaultLimitCORE=
+  DefaultLimitCORE=infinity
```
※ 特定のサービスがクラッシュ時にコアファイルを出力したい場合、drop-inファイルを作成し`DefaultLimitCORE`の設定値を変更といいかもしれません。  
  
設定を反映します。
```
$ sudo systemctl daemon-reexec
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
アップグレード対象となるパッケージをすべてコメントアウトし、アップグレードから除外するパッケージ(以下ではlinux-から始まるパッケージ名)を指定します。
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
# linux-から始まる名前のパッケージをホールド対象とする
$ sudo apt-mark hold $(dpkg-query -Wf '${Package}\n' | grep "^linux-")
```
ホールドしているパッケージ名を確認します。
```
$ apt-mark showhold
```
※ ホールド対象から除外するパッケージがある場合は、`apt-mark unhold`コマンドを使用する

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
$ sudo systemctl mask apt-daily.timer
$ sudo systemctl mask apt-daily.service
$ sudo systemctl mask apt-daily-upgrade.timer
$ sudo systemctl mask apt-daily-upgrade.service
$ sudo systemctl mask unattended-upgrades.service

# cron.serviceがあるため不要
$ sudo systemctl disable --now atd.service
```
※ cronなどで起動させられたサービスは`disable`であっても起動することに注意する(disableは自動起動を無効化する設定のため)

## ■ [任意] cloud-initの設定
ここでは、cloud-initの無効化を行います。
```
$ sudo touch /etc/cloud/cloud-init.disabled
```
`/etc/cloud/cloud-init.disabled`ファイルを作成することでcloud-init関連のサービスはすべて自動起動されないようになります(だだし、サービスとしての自動起動設定は入ったまま)

## ■ ユーザ/グループの設定
### rootのパスワード設定
以下では、sudo権限を持つユーザ(thetaru)を利用してrootのパスワードを設定します。
```
$ sudo passwd root
```
```
[sudo] password for thetaru:
New password:
Retype new password:
```

## ■ PAMの設定
PAMの設定は[PAM]()を参照してください。

## ■ ロギングの設定
### rsyslogの設定
rsyslogの設定は[rsyslog]()を参照してください。

### journalctlの設定
journalctlの設定は[journalctl]()を参照してください。

### logrotateの設定
logrotateの設定は[logrotate]()を参照してください。

## ■ ufwの設定
ufwの設定は[ufw]()を参照してください。

## ■ apparmorの設定
apparmorの設定は[apparmor]()を参照してください。

## ■ SSHサーバの設定
SSHサーバの設定は[SSH]()を参照してください。
