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
MariaDBをインストールします
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
Enter current password for root (enter for none):
OK, successfully used password, moving on...

Setting the root password ensures that nobody can log into the MariaDB
root user without the proper authorisation.

Set root password? [Y/n] y
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!

Remove anonymous users? [Y/n] y
 ... Success!

Disallow root login remotely? [Y/n] y
 ... Success!

Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!

Reload privilege tables now? [Y/n] y
 ... Success!

Cleaning up...

All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
```
