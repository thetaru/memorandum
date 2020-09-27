# ZabbixのInstall
インストールの流れは公式をみればいいです。  
事前に必要な設定を記載します。
## ■ SELinuxの無効化
```
# vi /etc/selinuc/config
```
```
-  SELINUX=enforcing
+  SELINUX=disabled
```
