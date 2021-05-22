# PowerDNS(Authoritative Server)のインストール
## ■ MariaDBのインストール
```
# yum install mariadb-server
```
## ■ MariaDBの設定
最低限の設定をします。  
チューニングに関しての説明は省きます。
```
# systemctl enable --now mariadb.service
# mysql_secure_installation
```
MariaDBにPowerDNS用のデータベースとユーザーを作成します。  
|設定|設定値|
|:---|:---|
|データベース名|powerdns|
|ユーザ名|pdns|
|パスワード|(任意設定)password|

```
# mysql -u root -p
> CREATE DATABASE powerdns CHARACTER SET utf8;
> CREATE USER 'pdns'@'127.0.0.1' IDENTIFIED BY 'password';
> GRANT ALL PRIVILEGES ON powerdns.* TO 'pdns'@'127.0.0.1';
```
## ■ PowerDNSのインストール
[公式](https://repo.powerdns.com/)を参考にしつつインストールします。  
ちなみにRecursorはキャッシュサーバでAuthoritativeは権威のことを指しています。  
今回は権威DNSサーバを立てるのでAuthoritativeを選択します。
```
# yum install epel-release &&
dnf install -y 'dnf-command(config-manager)' &&
curl -o /etc/yum.repos.d/powerdns-auth-master.repo https://repo.powerdns.com/repo-files/centos-auth-master.repo &&
yum install pdns
```

