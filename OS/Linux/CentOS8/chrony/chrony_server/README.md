# chronyサーバの構築
## ■ chronyの設定
```
# vi /etc/chrony.conf
```
```
### デフォルトのNTPサーバと時刻同期しない場合は無効化
-  pool 2.rhel.pool.ntp.org iburst
+  #pool 2.rhel.pool.ntp.org iburst

### 上位のNTPサーバ(IP or FQDN)を指定
### 上位のNTPサーバがDNSラウンドロビンされているならpoolを使うのも手です
+  server <上位NTPサーバ> iburst

### step無効化
-  makestep 1.0 3
+  #makestep 1.0 3

### slew設定
+  leapsecmode slew
+  maxslewrate 1000
+  smoothtime 50000 0.01 leaponly

### クライアントからのアクセス許可NWを指定
+  allow <ALLOW_NW>

### [Option] クライアントからのアクセス不可NWを指定
+  deny <DENY_NW>

### [Option] 上位NTPサーバと時刻同期できなくなった際にローカルタイム(RTC)を使用してクライアントと時刻同期
-  #local stratum 10
+  local stratum 10
```
IPv4のみを使用する場合は以下も実施してください。
```
# vi /etc/sysconfig/chronyd
```
```
-  OPTIONS=""
+  OPTIONS="-4"
```
## ■ chronydの起動と自動起動設定
```
# systemctl start chronyd.service
# systemctl enable chronyd.service
```
```
### 確認
# systemctl status chronyd.service
```
