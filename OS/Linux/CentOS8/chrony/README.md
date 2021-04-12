# chrony
|同期モード|説明|
|:---|:---|
|step|システムクロックをNTPサーバから取得した時刻へ即座に修正する|
|slew|システムクロックをNTPサーバから取得した時刻へ徐々に修正する|

## ■ Settings
- [ ] [サーバ側の設定]()
- [ ] [クライアント側の設定]()
# Server側の設定
## ■ Install
```
# yum install chrony
```
```
### バージョン確認
# rpm -qa | grep chrony
```
```
chrony-3.5-1.el8.x86_64
```
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
## ■ 設定の解説
# クライアント側の設定
```
# yum install chrony
```
```
### バージョン確認
# rpm -qa | grep chrony
```
```
chrony-3.5-1.el8.x86_64
```
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

### [Option]stratumの値に応じて優先度の重み付けする(0で無意味化する)
+  stratumweight 0

### step無効化
-  makestep 1.0 3
+  #makestep 1.0 3

### slew設定
+  leapsecmode slew
+  maxslewrate 1000
+  smoothtime 50000 0.01 leaponly

### クライアントとして動作させます。(123ポートでListenをしない)
+  port 0
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
