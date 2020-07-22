# リポジトリ
## §1. 実行環境
```
OS: CentOS8
media: DVD(isoイメージでも可)
```
## §2. 設定方法
### 2.1 マウント
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
baseurl=file:///media/BaseOS/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial

[InstallMedia-AppStream]
name=Red Hat Enterprise Linux 8 - AppStream
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file:///media/AppStream/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
```
メディアのマウント先が```/media```でない場合は、```baseurl```の値を変更する必要があります。  
また、RHEL8とで```gpgkey```の値が変わることに注意します。
### 2.3 キャッシュクリア
```
# yum clean all
```
念のためリポジトリが読まれていることを確認します。
```
# yum repolist
```
```
repo id                      repo の名前                                   状態
InstallMedia-AppStream       Red Hat Enterprise Linux 8 - AppStream        4,681
InstallMedia-BaseOS          Red Hat Enterprise Linux 8 - BaseOS           1,655
```
こんな感じになっていればOKです。
