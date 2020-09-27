# ZabbixのInstall
## SELinuxの無効化
```
# vi /etc/selinuc/config
```
```
-  SELINUX=enforcing
+  SELINUX=disabled
```
## MariaDBのインストール
```
# yum install maridb mariadb-server
```
MariaDBを起動します
```
# systemctl start mariadb
# systemctl enable mariadb
```
MariaDBのrootユーザーの初期パスワードを設定します
```
# /usr/bin/mysql_secure_installation
```
```
### Enterを押す
Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

### rootパスワードを設定しますか?
Set root password? [Y/n] y
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!

### 匿名ユーザを削除しますか?
Remove anonymous users? [Y/n] y
 ... Success!

### rootでのリモートログインを禁止しますか?
Disallow root login remotely? [Y/n] y
 ... Success!

### テストDBの削除をしますか?
Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

### 権限の変更を再読み込みしますか?
Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```
## phpのインストール
```
# yum intall php php-fpm
```
```
# vi /etc/php-fpm.d/zabbix.conf
```
```
-  ; php_value[date.timezone] = Europe/Riga
+  php_value[date.timezone] = Asia/Tokyo
```
## apacheのインストール
```
# yum install httpd
```
## zabbixのインストール
```
# rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/8/x86_64/zabbix-release-5.0-1.el8.noarch.rpm
```
```
# yum clean all
```
```
# yum install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
```
