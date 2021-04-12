# chronyクライアントの設定
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
