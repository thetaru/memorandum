# CentOS8
- [ ] [テンプレート](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/_Template)
## ■ MEMO
```
# 追加
networkmanager

basicconfの内容を更新する。 参照させるようにすること。
nftables書き直す

## 機能調査
apache 未整理
samba 数パターンつくる
パスワードポリシーについて(login.defs)
postgreSQL
haproxy

lets encrypt でワイルドカード証明書
```
## ■ Commands
- [x] [chroot](chroot)
- [x] [rsync](rsync)
- [ ] [certtool](certtool)
- [ ] [parted](parted)
- [ ] [systemctl](systemctl)

## ■ OS Settings
- [ ] [Basic Configuration](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/settings)
- [x] [Bonding + VLAN](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Bonding_VLAN)
- [x] [cron](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/cron_note)
- [x] [filedescriptor](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/filedescriptor)
- [x] [firewalld](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/firewalld)
- [x] [ipv6無効化](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Ipv6無効化)
- [x] [kdump](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/kdump)
- [ ] [LVM](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/LVM)
- [ ] [networkmanager](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/networkmanager)
- [x] [nftables](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/nftables)
- [x] [repository](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/repository)
- [ ] [SELinux](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/SELinux)
- [ ] [SNMP](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/about_snmp)
- [x] [xfsファイルシステムのバックアップとリストア方法](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/xfs_backup)
- [x] [xfsクォータ](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/xfs_quota)
- [x] [xrdp](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/xrdp)
- [ ] [パスワードポリシーの設定](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/PasswordPolicy)
- [ ] [ローカルミラー](localmirror)

## ■ Software Settings
- [x] [Ansible](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Ansible)
- [ ] [apache](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/apache)
- [ ] [BIND](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/BIND)
- [x] [chrony](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/chrony)
- [ ] [(書きかけ)Digdag](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/digdag)
- [ ] [Docker](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Docker)
- [ ] [DRBD](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/DRBD)
- [ ] [Elasticsearch](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Elasticsearch)
- [x] [GitLab](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/GitLab)
- [ ] [Kubernetes](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/k8s)
- [x] [NFS](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/nfs)
- [ ] [minecraft](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/minecraft)
- [ ] [(書きかけ)HAProxy](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/haproxy)
- [ ] [Oracle Databse](Oracle_Databse)
- [ ] [(書きかけ)Postfix](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/postfix)
- [ ] [(書きかけ)PostgreSQL](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/PostgreSQL)
- [ ] [Samba](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Samba)
- [ ] [Squid(Forward Proxy)](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Squid)
- [ ] [SSH](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/SSH)
- [ ] [syslog](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/syslog)
- [ ] [VirtualBox](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/virtualbox)
- [ ] [Zabbix](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Zabbix)
## ■ Tips
- [x] [OOM-Killerにヤられないために](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/oom_killer)
- [x] [ゲートウェイサーバの構築](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/gateway_srv)
- [x] [スタティックルートの設定](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/StaticRoute)
- [x] [アプデの際の注意](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/update_note)
- [ ] [CoreDNS+k8sで作る内部DNSサーバ](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/internal_coredns)
- [ ] [ログイン時の警告バナーの設定](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/login_banner)
- [ ] [ファイルシステムのマウント順序を指定する方法](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/mount_order)
- [ ] [よく必要になるコマンドのパッケージ](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/required_packages)
- [ ] [サーバにログインしたらやること](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/server_status)
- [ ] [サーバのセキュリティ事項](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/server_security)
- [ ] [パーティションのサイズを変更する](resize_partition)
- [ ] [HTTPヘッダー カスタムヘッダの確認](custom_header)
- [ ] [多段SSHでRDP接続する方法](ssh_portforward)
- [ ] [~~MetalLB+BINDで内部DNSサーバ構築~~](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/bind_k8s_gitlab)

## ■ Development
- [ ] [Jupyter Notebook](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/JupyterNotebook)
- [ ] [React 開発環境構築](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/development_react)
