# OS設定変更点
- /etc/selinux/config
  - disableがなくなったためgrubから無効化する必要がある
- /etc/default/grub
  - selinuxを変更できる kdumpの予約メモリがメモリ依存に変わった(メモリ依存なのは変わらないけど明示的になった)
- /etc/systemd/system.conf
  - パラメータが増えてた(ulimit...)
- /etc/ssh/sshd_config
  - PermitRootLogin prohibit-password となっているためrootでのパスワード認証が通らない(はじめはyesにして後で)
- sshのプロセスが取る引数が変わっていた(要確認)
- yum install epel-releaseできない
  - dnf config-manager --set-enabled crb
  - dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
  - dnf install https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

- NetworkManagerの挙動が違う
  - /etc/NetworkManager/system-connections配下で管理しているように見える
  - 一方で、/etc/sysconfig/network-scripts配下は空となっていた(deprecatedのため)
