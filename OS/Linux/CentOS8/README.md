# CentOS8
- [ ] [テンプレート](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/_Template)
## ■ MEMO
```
## 新テンプレートに移行
SMB
HAProxy
BIND
apache
postfix
chrony
mariadb
squid
nfs
firewalld
nftables

## 機能調査
BIND
samba 数パターンつくる
postfix 全部プラスじーめーる(優先度: 高)
SNMpについて
パケットキャプチャについて
コアダンプについて
カーネルパラメータについて
パスワードポリシーについて(login.defs)
mariadb(やったほうがいいためになる)
postgreSQL(やったほうがいいためになる)
keepalive
haproxy
xfsquota 挙動についての調査
LDAP

tmpfs
fragmentation
lets encrypt でワイルドカード証明書
```
## ■ Commands
- [x] [chroot](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/chroot)
- [x] [rsync](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/rsync)
## ■ OS Settings
- [ ] [Basic Configuration](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/settings)
- [x] [Bonding + VLAN](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Bonding_VLAN)
- [x] [ファイルディスクリプタ](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/filedescriptor)
- [x] [firewalld](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/firewalld)
- [x] [ipv6無効化](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Ipv6無効化)
- [x] [kdump](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/kdump)
- [x] [nftables](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/nftables)
- [x] [repository](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/repository)
- [ ] [(書く気が起きない)syslog](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/syslog)
- [x] [xfsファイルシステムのバックアップとリストア方法](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/xfs_backup)
- [x] [xfsクォータ](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/xfs_quota)
- [x] [xrdp](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/xrdp)
- [ ] [(必要になった)パスワードポリシーの設定](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/PasswordPolicy)

## ■ Software Settings
- [x] [Ansible](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Ansible)
- [ ] [(書きかけ)AWX](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/AWX)
- [x] [apache](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/apache)
- [ ] [BIND](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/BIND)
- [ ] [Docker](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Docker)
- [ ] [Elasticsearch](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Elasticsearch)
- [x] [GitLab](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/GitLab)
- [ ] [Kubernetes](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/k8s)
- [ ] [(書きかけ)LDAP](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/LDAP)
- [x] [NFS](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/nfs)
- [x] [NTP(chrony)](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/chrony)
- [ ] [(書きかけ)mariadb](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/mariadb)
- [ ] [minecraft](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/minecraft)
- [ ] [(必要になったらヤル)haproxy](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/haproxy)
- [ ] [(書きかけ)Postfix](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/postfix)
- [ ] [(書きかけ)PostgreSQL](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/PostgreSQL)
- [ ] [Samba](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Samba)
- [ ] [Squid](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Squid)
- [ ] [VirtualBox](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/virtualbox)
- [ ] [Zabbix](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Zabbix)
## ■ Tips
- [x] [OOM-Killerにヤられないために](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/oom_killer)
- [ ] [(やるか悩んでる)AnsibleとGitLabでCI/CD環境構築](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/Ansible+GitLab)
- [x] [tmux](https://github.com/thetaru/memorandum/edit/master/OS/Linux/CentOS8/tmux)
- [ ] [(書きかけ)tmpfsについて](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/about_tmpfs)
- [ ] [(書きかけ)メモリ断片化について](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/memory_fragmentation)
- [ ] [(書きたい)SNMPについて](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/about_snmp)
- [ ] [(書きたい)コアダンプについて](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/about_coredump)
- [ ] [(書きたい)カーネルパラメータについて](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/about_KernelParam)
- [x] [ゲートウェイサーバの構築](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/gateway_srv)
- [x] [スタティックルートの設定](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/StaticRoute)
- [x] [アプデの際の注意](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/update_note)
- [ ] [~~MetalLB+BINDで内部DNSサーバ構築~~](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/bind_k8s_gitlab)
- [ ] [CoreDNS+k8sで作る内部DNSサーバ](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/internal_coredns)

