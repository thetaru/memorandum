# Settings
インストーラ時に最小インストール(Minimal Install)を選択しているものとして進める。
## ■ [任意] デフォルトエディタの設定
デフォルトエディタをvimに設定します。
```
$ sudo update-alternatives --set editor /usr/bin/vim.basic
```
## ■ ホスト名の設定
```
$ sudo hostnamectl set-hostname <hostname>
```

## ■ ブートローダーの設定
```
$ sudo vim /etc/default/grub
```
```diff
-  GRUB_CMDLINE_LINUX=""
+  GRUB_CMDLINE_LINUX="consoleblank=0 crashkernel=auto rhgb quiet ipv6.disable=1"
```
設定を反映します。
```
$ sudo update-grub2
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
$ sudo sysctl -p
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

## ■ パッケージのアンインストール
不要なパッケージを削除します。
```
## パッケージ利用調査用ツール
$ sudo apt purge --autoremove popularity-contest

## パッケージ情報更新ツール
$ sudo apt purge --autoremove update-manager-core

## パッケージ自動更新ツール
$ sudo apt purge --autoremove unattended-upgrades

## ファームウェア自動更新ツール
$ sudo apt purge --autoremove fwupd

## [オプション] netplan
$ sudo apt purge --autoremove netplan.io
```
## ■ パッケージのインストール
必要なパッケージがあれば適宜インストールすること。

## ■ パッケージアップデート
パッケージリストをアップデートします。
```
$ sudo apt update
```
パッケージリストをもとにパッケージをアップグレードします。
```
$ sudo apt upgrade
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

## ■ 名前解決の設定
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

### systemd-resolvedの設定
システムに設定されている名前解決先のDNSサーバと`resolv.conf mode`(デフォルトはstub)を確認する。
```sh
$ resolvctl status
```
```
$ sudo vi /etc/systemd/resolved.conf
```
```
[Resolve]
# DNSサーバを指定する(半角スペース区切り)
DNS=<dnsサーバ1> <dnsサーバ2>

# スタブリゾルバを使用しない
DNSStubListener=no
```
`/etc/resolv.conf`のシンボリックリンクを`/run/systemd/resolve/resolv.conf`に張り替えます。
```sh
$ sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```
設定を反映します。
```
$ sudo systemctl restart systemd-resolved.service
```
DNSサーバと`resolv.conf mode`の設定が反映されていることを確認します。
```
$ resolvectl status
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
$ sudo vim /etc/systemd/timesyncd.conf
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
kdump-tools.serviceが動作していることを確認します。
```sh
$ systemctl status kdump-tools.service
```

## ■ コアダンプの設定
ソフトウェア(OSを含む)がクラッシュした際に、そのソフトウェアが使用していたメモリ上の内容をファイルに出力します。  
コアダンプの出力をするかしないかはプロジェクトのポリシーにも依存します。(メモリ情報に機密情報を含む場合があるため)  
  
`apport.service`が有効であることを確認します。(デフォルトで有効(enable)のはず)
```
$ systemctl status apport.service
```
apport機能が有効になっていることを確認します。
```
$ sudo vim /etc/default/apport
```
```
enabled=1
```
コアファイルのサイズの最大値を無制限に変更します。
```
$ sudo vim /etc/systemd/system.conf
```
```diff
-  #DefaultLimitCORE=
+  DefaultLimitCORE=infinity
```
※ 特定のサービスがクラッシュ時にコアファイルを出力したい場合、drop-inファイルを作成し`DefaultLimitCORE`の設定値を変更といいかもしれません。  
  
設定を反映します。
```
$ sudo systemctl daemon-reexec
```

## ■ 不要なサービスの停止
```
# パッケージ自動更新周りのサービスを無効化
$ sudo systemctl disable --now apt-daily.timer
$ sudo systemctl disable --now apt-daily-upgrade.timer
$ sudo systemctl disable --now ua-timer.timer
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

## ■ [任意] ログイン時に出力されるメッセージ(MOTD)の抑止
出力用のスクリプトは`/etc/update-motd.d/`に配置されている。(カスタマイズする場合は、このスクリプトを修正する。)  
以下では、PAMによる抑止を行っている。
```sh
# SSHログイン時
$ sudo vim /etc/pam.d/sshd
```
```diff
-  session    optional     pam_motd.so  motd=/run/motd.dynamic
+  #session    optional     pam_motd.so  motd=/run/motd.dynamic
```
```sh
# コンソールログイン時
$ sudo vim /etc/pam.d/login
```
```diff
-  session    optional     pam_motd.so  motd=/run/motd.dynamic
+  #session    optional     pam_motd.so  motd=/run/motd.dynamic
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
