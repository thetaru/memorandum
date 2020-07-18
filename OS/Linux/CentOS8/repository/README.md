# リポジトリ
## §1. 実行環境
```
OS: CentOS8
media: DVD(isoイメージでも可)
```
## §2. 設定方法
### 2.1 DVDマウント
```
# mount -o loop /dev/sr0 /media
```
### 2.2 リポジトリ作成
```
# vi /etc/yum.repos.d/local.repo
```
```local.repo```に以下の内容を記述します。
```
[InstallMedia-BaseOS]
name=Red Hat Enterprise Linux 8 - BaseOS
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///media/rhel8dvd/BaseOS/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[InstallMedia-AppStream]
name=Red Hat Enterprise Linux 8 - AppStream
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///media/rhel8dvd/AppStream/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
```
RHEL8とでgpgkeyの値が変わることに注意します。
### 2.3 キャッシュクリア
```
# yum clean all
```
