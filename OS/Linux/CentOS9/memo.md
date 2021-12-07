# OS設定変更点
- /etc/selinux/config
  - disableがなくなったためgrubから無効化する必要がある
- /etc/default/grub
  - selinuxを変更できる kdumpの予約メモリがメモリ依存に変わった(メモリ依存なのは変わらないけど明示的になった)
- /etc/systemd/system.conf
  - パラメータが増えてた(ulimit...)
- sshのプロセスが取る引数が変わっていた(要確認)
