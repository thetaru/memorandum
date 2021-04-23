# SNMPトラップの有効化
## パッケージインストール
```
# dnf install net-snmp net-snmp-utils net-snmp-perl
```
## SNMPトラップハンドリング用スクリプトの配置と設定
zabbixのversionは`rpm -qa`などで確認してください。
```
# wget https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-<version>.tar.gz
# tar zxvf zabbix-<version>.tar.gz
# cp -p zabbix-<version>/misc/snmptrap/zabbix_trap_receiver.pl /usr/local/bin/
```
スクリプト内にあるログファイルのパスを設定します。
```
# vi /usr/local/bin/zabbix_trap_receiver.pl
```
```
-  $SNMPTrapperFile = '/tmp/zabbix_traps.tmp';
+  #$SNMPTrapperFile = '/tmp/zabbix_traps.tmp';

+  $SNMPTrapperFile = '/var/log/snmptrap/snmptrap.log';
```
SNMPTrapperFileで指定したファイルが存在しないとエラーが吐かれるので空ファイルを作成します。
```
# touch /var/log/zabbix/snmptrap.log
# chown zabbix:zabbix /var/log/zabbix/snmptrap.log
```
所有者と実行権限を変更します。
```
# chown zabbix:zabbix /usr/local/bin/zabbix_trap_receiver.pl
# chmod +x /usr/local/bin/zabbix_trap_receiver.pl
```
## snmptrapdの設定
SNMPのバージョンとコミュニティ名を指定して編集します。
```
# vi /etc/snmp/snmptrapd.conf
```
```
+  authCommunity log,execute,net <Community Name>
+  perl do "/usr/local/bin/zabbix_trap_receiver.pl"
```
snmptrapdのパラメータを設定します。  
MIBの読み込みとログ出力先ファシリティをlocal 6に変更します。
```
# vi /etc/sysconfig/snmptrapd
```
```
-  OPTIONS="-Lsd"
+  OPTIONS="-m +ALL -Ls6 -On -p /var/run/snmptrapd.pid"
```
## snmptrapdの起動
```
# systemctl enable --now snmptrapd
```
## Zabbixサーバの設定
```
# vi /etc/zabbix/zabbix_server.conf
```
```
-  #StartSNMPTrapper=0
+  StartSNMPTrapper=1
```
zabbixの再起動を行います。
```
# systemctl restart zabbix-server
```
