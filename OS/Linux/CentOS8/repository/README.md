# リポジトリ
## §1. 実行環境
```
OS: CentOS8
media: DVD(isoイメージでも可)
```
## §2. 設定方法
### 2.1 マウント
isoイメージをマウントする場合は```/dev/sr0```をisoイメージと差し替えます。
```
# mount -o loop /dev/sr0 /media
```
### 2.2 リポジトリ登録
リポジトリの設定ファイルを作成します。
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
また、RHEL8では`gpgkey`の値が`file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release`に変わることに注意します。
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

## §3. おまけ
以降の内容はCentOS8からの内容となります。
### 3.1 リポジトリの有効化
EPELやPowerToolsなどのリポジトリはデフォルトで利用できないので、有効化します。
#### EPEL
```
# yum install epel-release
```
#### PowerTools
```
# vi /etc/yum.repos.d/CentOS-Stream-PowerTools.repo
```
```
### 無効: 0 有効: 1
-  enabled=0
+  enabled=1
```
