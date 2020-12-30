# IPv6無効化
## 方法1: カーネルパラメータより
### :warning:注意事項:warning:
```NetworkManager```サービスを使用しているシステムでカーネルパラメータを変更することは***非推奨***です。
### §1. カーネルパラメータの確認
IPv6が有効になっていることを確認します。
```
# sysctl -a | grep -e all.disable_ipv6 -e default.disable_ipv6
```
```
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
```
### §2. カーネルパラメータの変更
```
# vi /etc/sysctl.conf
```
IPv6を無効化するパラメータを追記します。
```
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
```
```/etc/sysctl.conf```に```net.ipv6.conf.all.disable_ipv6``` や ```net.ipv6.conf.default.disable_ipv6```のパラメータが**ない**なら  
以下のコマンドでもいいです。
```
# echo "net.ipv6.conf.all.disable_ipv6 = 0" >> /etc/sysctl.conf
# echo "net.ipv6.conf.default.disable_ipv6 = 0" >> /etc/sysctl.conf
```
### §3. カーネルパラメータの反映
OSを再起動するか次のコマンドを実行します。
```
# sysctl -p
# systemctl restart network.service
```
IPv6が無効化されていることを確認します。
```
# sysctl -a | grep -e all.disable_ipv6 -e default.disable_ipv6
# ip a
```
```net.ipv6.conf.all.disable_ipv6``` と ```net.ipv6.conf.default.disable_ipv6```のパラメータの値が```1```になっていて  
IPv6アドレスが設定されていなければOKです。
## 方法2: GRUBより
### §1. `/etc/default/grub`を編集する
`/etc/default/grub`の`GRUB_CMDLINE_LINUX`に`ipv6.disable=1`を設定(追記)します。
```
# vi /etc/default/grub
```
```
-  GRUB_CMDLINE_LINUX="..."
+  GRUB_CMDLINE_LINUX="... ipv6.disable=1"
```
### §2. `grub.cfg`を再生成する
#### BIOS
```
# grub2-mkconfig -o /boot/grub2/grub.cfg
```
#### UEFI
```
# grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```
再起動します。
