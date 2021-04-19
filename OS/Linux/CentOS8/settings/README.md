# Settings
## ■ ホスト名の設定
```
# hostnamectl set-hostname <hostname>
```
## ■ [Static]IPアドレス設定
認識しているデバイスを確認します。
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
<summary>NICを後から追加した場合</summary>
   
```
# nmcli connection add type ethernet con-name <CONNECTIONNAME> ifname <DEVICENAME>
```

</details>

`nmcli connection modify`を使って設定します(:warning: `/etc/sysconfig/network-script/ifcfg-ensxxx`に反映されます)  
`ensxxx`は環境に応じて置き換えて設定してください。
```
# nmcli connection modify ensxxx connection.autoconnect yes
# nmcli connection modify ensxxx ipv4.method manual ipv4.address <ip-address>/<prefix>
# nmcil connection modify ensxxx ipv4.may-fail no
```
```
### ゲートウェイを設定する場合
# nmcli connection modify ensxxx ipv4.gateway <gateway-address>
### ゲートウェイを設定しない場合
# nmcli connection modify ensxxx ipv4.never-default yes
```
```
### DNSをNetworkManagerで管理する場合(しない場合は後述の方法で無効化すること)
# nmcli connection modify ensxxx ipv4.dns "<dns1-address> <dns2-address>"
```
無線LANとワイヤレスWANを無効化します。
```
# nmcli radio all off
```
デバイスを再起動して設定を反映させます。
```
# nmcli connection up ensxxx
```
```
接続が正常にアクティベートされました (D-Bus アクティブパス: /org/freedesktop/NetworkManager/ActiveConnection/3)
```
設定値を確認します。
```
# nmcli device show ensxxx
# nmcli networking connectivity
# nmcli radio all
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
設定を反映します。
```
# sysctl --load /etc/sysctl.d/70-ipv6.conf
```
```
# systemctl reboot
```
IPv6が設定が無効化されていることを確認します。
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

<details>
<summary>[option]/etc/resolv.confの自動更新の無効化</summary>

例えばDHCPサーバからIPアドレスを取得している場合、DNSも渡されたものを`/etc/resolv.conf`に設定してしまうので無効化します。
```
# vi /etc/NetworkManager/NetworkManager.conf
```
```
[main]
+  dns=none
```
</details>

<details>
<summary>[option]スタティックルートの追加/削除</summary>
 
 スタティックルートの追加と削除は次の通りです。
 ```
 ### 追加
 # nmcli connection modify ensXXX +ipv4.routes "192.168.137.0/24 192.168.1.1"
 ```
 ```
 ### 削除
 # nmcli connection modify ensXXX -ipv4.routes "192.168.137.0/24 192.168.1.1"
 ```
   
</details>
 
<details>
<summary>[option]Bondingの設定</summary>

|No.|モード|説明|
|:---|:---|:---|
|0|balance-rr|ラウンドロビン方式で送信|
|1|active-backup|アクティブ/バックアップ方式|
|2|balance-xor||
|3|broadcast||
|4|802.3ad||
|5|balance-tlb|スレーブの負荷に応じて送信スレーブを決定しパケットを送信|
|6|balance-alb|balance-tlbの機能に加え、受信も負荷分散|

### masterの作成
ここでは例として`bond0`というデバイスを作成します。
```
# nmcli connectin add type bond ifname bond0 con-name bond0 mode balance-rr
```
### slaveの追加
作成した`bond0`のslaveとなるインターフェース`ensxxx`を追加します。
```
### masterにスレーブensxxxを追加する
# nmcli connection add type ethernet ifname ensxxx master bond0
```
masterに追加するインターフェースを上と同様の手順で追加します。
### コネクションの有効化
```
# nmcli connection up bond0
```
### 設定の確認
```
# cat /proc/net/bonding/bond0
# nmcli connection

### ActiveなNICがわかる
# grep 'Active Slave:' /proc/net/bonding/bond0
```
</details>

<details>
<summary>[option]ethtool</summary>
   
ethtoolでやるやつ `auto-negotitation`あたりを設定しよう
   
</details>

## ■ DNSの設定
上記で`/etc/resolv.conf`の自動更新を無効化した人向けです。
```
# vi /etc/resolv.conf
```
```
+  search <domain>

+  nameserver <DNS1 Server>
+  nameserver <DNS2 Server>
```
<details>
<summary>[option]NetworkManagerの挙動</summary>

デフォルトのNetworkManagerのDNS設定は(アクティブなインターフェイスの)設定ファイル(/etc/sysconfig/network-script/ifcfg-<device name>)に記載のDNSサーバとサーチドメインをまとめています。  
  
`/etc/NetworkManager/NetworkManager.conf`で設定した`dns=none`は  
`/etc/sysconfig/network-script/ifcfg-`を参照しないことで`/etc/resolv.conf`の自動更新を無効化するということを意味するようです。

</details>

## ■ networkの設定
:warning: `/etc/sysconfig/network`に`Networking=yes`がデフォルトで入っているがこれを消しても疎通が取れてしまう。  
`nmcli networking on`は別ファイルを参照・変更していそう。
```
# vi /etc/sysconfig/network
```
```
### 不要なルーティングテーブルの作成を防ぐ(RHEL8では不要なルーティングが自動作成されないので不要です)
+  NOZEROCONF=yes

### システム起動時にNWを有効化
+  NETWORKING=yes

### IPv6の無効化
+  NETWORKING_IPV6=no
```
## ■ hostsの設定
```
# vi /etc/hosts
```
```
### IPv6を使わない場合は無効化
-  ::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
+  #::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
```
## ■ 不要なサービスの停止
調査中...
```
### いらないサービス(メモ)
# disable_arr = [atd.service bluetooth.service ksm.service ksmtuned.service libvirtd.service mdmonitor.service]

# systemctl stop <service>
# systemctl disable <service>
```
## ■ カーネルアップデート抑止
`/etc/yum.conf`は`/etc/dnf/dnf.conf`のシンボリックリンクなので`dnf.conf`を編集します。
### Xあり
```
# vi /etc/dnf/dnf.conf
```
```
+  excludepkgs=kernel* centos* xorg*
```
### Xなし
```
# vi /etc/dnf/dnf.conf
```
```
+  excludepkgs=kernel* centos*
```
### 万が一アップデートされた場合の設定
```
### カーネルアップデートされても、新しいカーネルで起動しない
# vi /etc/sysconfig/kernel
```
```
-  UPDATEDEFAULT=yes
+  UPDATEDEFAULT=no
```
脆弱性対処の際にはこれらの設定を外してから`yum update`します。
## ■ 自動パッケージアップデートの無効化
X Windows Systemを入れると自動アップデートツールが有効になるため無効化します。  
CUI環境の場合は不要な手順です。
```
# systemctl stop packagekit
# systemctl stop packagekit-offline-update.service
# systemctl mask packagekit
# systemctl mask packagekit-offline-update.service
```
## ■ [Option] シェルの制限設定
systemdコントロール下のプロセスのデフォルト値を変更します。
```
# mkdir /etc/systemd/system.conf.d
# chown root:root /etc/systemd/system.conf.d
# chmod 755 /etc/systemd/system.conf.d
```
```
# vi /etc/systemd/system.conf.d/override.conf
```
```
[Manager]
### ファイルディスクリプタ数
+  DefaultLimitNOFILE=65536
### プロセス数
+  DefaultLimitNPROC=65536
```
設定を読み込ませます。
```
# systemctl daemon-reload
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

### [Option]パスワード認証を禁止(鍵でログイン管理する場合に設定)
-  PasswordAuthentication yes
+  PasswordAuthentication no

### 暗号化アルゴリズム
+  Ciphers aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

### 鍵交換アルゴリズム
+  KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group18-sha512,diffie-hellman-group16-sha512,diffie-hellman-group14-sha256,diffie-hellman-group-exchange-sha256

### MACアルゴリズム
+  Macs umac-128-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-64-etm@openssh.com,umac-64@openssh.com,hmac-sha1

### ホスト間認証アルゴリズム
+  HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,ecdsa-sha2-nistp256,ssh-rsa-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256,ssh-rsa

### 鍵生成の頻度(何バイトの鍵を何秒毎に生成するか)を指定
+  RekeyLimit default 600

### [Option]ログイン可能ユーザーの制御
### Case1. 接続許可ユーザ設定
+  AllowUsers <USER>
### Case2. 複数の接続許可ユーザ設定
+  AllowUsers <USER1> <USER2>
### Case3. 特定のIPアドレスからのみ接続許可ユーザ設定
+  AllowUsers <USER>@<接続元IP>
### Case4. 特定のIPアドレスからのみ接続許可(全ユーザ)
+  AllowUsers *@<接続元IP>
### Case5. 特定のネットワークからのみ接続許可
+  AllowUsers <USER>@192.168.137.0/24
```
このままだと設定したアルゴリズム以外のものも使おうとするので`/etc/sysconfig/sshd`を編集します。  
この設定ファイルは`/etc/systemd/system/multi-user.target.wants/sshd.service`で読み取られます。
```
# vi /etc/sysconfig/sshd
```
```
-  # CRYPTO_POLICY=
+  CRYPTO_POLICY=
```
設定が完了したらサービスを再起動します。
```
### sshdを再起動
# systemctl restart sshd
```
ちなみに設定できる`Ciphers`,`MACs`,`KexAlgorithms`,`PubkeyAcceptedKeyTypes`は以下のコマンドで確認できます。
```
# ssh -Q cipher
# ssh -Q mac
# ssh -Q kex
# ssh -Q key
```
## ■ セキュリティポリシーの設定
基本的に`DEFAULT`ポリシーでいいと考えている
```
### 現在適用中のポリシーを確認
# update-crypto-policies --show
```
次のポリシーの一つを適用する  
`DEFAULT`,`LEGACY`,`FUTURE`,`FIPS`
```
# update-crypto-policies --set [POLICY]
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
# systemctl start firewalld

### 自動起動の無効化
# systemctl enable firewalld
```
2. **無効**にする場合
```
### サービスの無効化
# systemctl stop firewalld

### 自動起動の無効化
# systemctl disable firewalld
```
ここでは、firewalldの詳しい設定は行いません。
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
## ■ 時刻同期(クライアント)の設定
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
+  server <ntp_server-address> iburst

### stepの無効化
-  makestep 1.0 3
+  #makestep 1.0 3

### slew設定
+  leapsecmode slew
+  maxslewrate 1000
+  smoothtime 400 0.001 leaponly

### どのポートでもリッスンしない(クライアントとしてのみ機能させる)
+  port 0

### [Option] 同期先の正常な時刻のNTPサーバが2台以上のときのみ同期する(デフォルトは1台)
-  #minsources 2
+  minsources 2
```
IPv4のみを使用するようにします。
```
# vi /etc/sysconfig/chronyd
```
```
-  OPTIONS=""
+  OPTIONS="-4"
```
chronyのサービスを起動します。
```
### chronyサービスの起動
# systemctl start chronyd
# systemctl enable chronyd
```
指定したNTPサーバと同期できていることを確認します。
```
### 同期状態の確認
# chronyc sources
```
```
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* <ntp-server>                1   6   377     9  +3649us[+5915us] +/-   30ms
```
時刻があまりにずれているようなら`chronyc makestep`を実行して強制的に同期させます。
## ■ pamの設定
`su` コマンドを実行できるユーザを制限します。  
:warning:例としてユーザ名は`thetaru`を使用しています。  
さらに細かく制限をかける場合は[こちら]()を参考にしてください。
```
### ユーザthetaru を グループwheelに追加
# gpasswd -a thetaru wheel
or
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
## ■ ユーザ権限の設定
```
### drop in
# vi /etc/sudoers.d/override
```
```
### sudoパスワードのキャッシュをしない(デフォルトは5分)
+  Defaults timestamp_timeout = 0

### sudoパスワードの試行回数制限(デフォルトは3回)
+  Defaults passwd_tries = 5

### [Option] tty経由以外のsudoを許可(デフォルトはttyのみ使用可能)
### Case1. この設定だと全ユーザが対象
+  Defaults requiretty

### Case2. ユーザを指定する場合(rootを許可)
+  Defaults requiretty
+  Defaults:root !requiretty

### Case3. グループを指定する場合(wheelグループを許可)
+  Defaults requiretty
+  Defaults:%wheel !requiretty
```
## ■ logrotateの設定
要件に合わせて設定してください。
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
IPv6の無効化やブラックアウトの無効化をします。  
物理マシンの場合はさらに細かい設定が必要な場合があるので注意しましょう。(物理マシンの詳細情報を読みましょう。)
```
# vi /etc/default/grub
```
```
-  GRUB_CMDLINE_LINUX="crashkernel=auto resume=UUID=<UUID> rhgb quiet"
+  GRUB_CMDLINE_LINUX="crashkernel=auto resume=UUID=<UUID> rhgb quiet consoleblank=0 ipv6.disable=1"
```
### BIOS
```
# grub2-mkconfig -o /boot/grub2/grub.cfg
```
### UEFI
```
# grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
```
## ■ カーネルパラメータの設定
https://gist.github.com/koudaiii/035120ed116ecf6f1b06  
https://note.com/ujisakura/n/n443807235887#o7Prw
```
# vi /etc/sysctl.conf
```
```
### /proc/sys/kernel/core_patternに反映される
### 逆に/proc/sys/kernel/core_patternを設定するとkernel.core_patternの値に反映される
### systemd-coredumpによるコアダンプ(RHEL8ではこの設定を変更するとコアダンプの採取が失敗します。)
+  kernel.core_pattern=/var/tmp/core-%e.%p

### setuidおよびsetgidプロセスに対するコアダンプの有効化
+  fs.suid_dumpable=2

### OOM Killer が実行に必ずカーネルパニックさせる
+  vm.panic_on_oom=2
```
```
### 設定の反映
# sysctl -p
```
## ■ コアダンプ出力設定
```
# vi /etc/systemd/coredump.conf
```
```
-  #Compress=yes
+  Compress=no
```
```
# vi /etc/systemd/system.conf
```
```
### コアダンプを出力する
-  #DumpCore=yes
+  DumpCore=yes

### コアダンプのデフォルトの最大値を無制限にする
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
-  module(load="imuxsock" SysSock.Use="off")
+  module(load="imuxsock" SysSock.Use="off" SysSock.RateLimit.Interval="0" SysSock.RateLimit.Burst="0")

-  module(load="imjournal" StateFile="imjournal.state")
+  module(load="imjournal" StateFile="imjournal.state" Ratelimit.Interval="0")
```
```
# systemctl restart rsyslog.service
# systemctl status rsyslog.service
```
ログ出力設定は[こちら]()を参考にしてください。
## ■ メール(クライアント)の設定
```
# vi /etc/postfix/main.cf
```
```
### 指定したNWから来たメールの中継を許可(複数指定可能)
mynetworks = <network address>

### 待ち受けインターフェイスを指定(allは全てのインターフェイスを指定)
inet_interfaces = all

### postfixが使用するインターネットプロトコルを指定
inet_protocols = ipv4

### 外部にメールを送信する際に、ローカルNW情報が流出しないよう書き換える
header_checks = regexp:/etc/postfix/header_checks
```
```
### ヘッダーの変更だけでなく受信拒否もできる
# vi /etc/postfix/header_checks
```
```
/(^Received:.*) \[[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\](.*)/ REPLACE $1$2
```
## ■ [option]Proxyの設定
```
# vi /etc/profile.d/proxy.sh
```
```
#!/bin/bash

### ProxyサーバのIPアドレスとポート番号を指定
PROXY="<Proxy-server Ip-address>:<Port>"
export http_proxy=$PROXY
export HTTP_PROXY=$PROXY
export https_proxy=$PROXY
export HTTPS_PROXY=$PROXY

### Proxy接続対象外を指定
export no_proxy="127.0.0.1,localhost"
```
```
### 反映
# source /etc/profile.d/proxy.sh
```
