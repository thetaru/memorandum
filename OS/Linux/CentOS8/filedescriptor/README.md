# ファイルディスクリプタ(FD)について
ファイルI/Oが頻繁に行われるプロセスはFD数の上限を上げておく必要があります。
## ■ 一般
|項目|説明|
|:---|:---|
|ソフトリミット|一般ユーザーが設定したFD数の制限値|
|ハードリミット|一般ユーザーが設定できるFD数の上限|

一般ユーザーはそのソフトリミットの範囲を超えたFD数になった場合にユーザに警告を出力するためにある。  
一般ユーザーはそのハードリミットの範囲内でしかFD数の値を変更できない。（この数値を超えることができません）  
面倒なら、同じ値でもいいのかなと思っている

## ■ OS全体でのFD数の上限
OS全体で定められるFD数の制限値は次のように確認できます。
```
# sysctl -a | grep fs.file-max
```
```
fs.file-max = 1592048
```
また`fs.file-max`の値を変更してもプロセスあたりの制限は影響を受けません。  
なので、OS全体のFD数を増やしてから、プロセスのFD数を変更しましょう。
### 変更方法
```
# vi /etc/sysctl.conf
```
```
+  fs.file-max = 1600000
```
## ■ プロセス単位でのFD数の制限
### 変更方法
```
### 最大FD数の確認
# cat /proc/`pgrep --parent 1 -f httpd`/limits | grep 'open files'
```
```
# mkdir /etc/systemd/system/httpd.service.d
# chown root:root /etc/systemd/system/httpd.service.d
# chmod 755 /etc/systemd/system/http.service.d
```
```
### ファイル名は末尾が.confであれば何でもいいです
# vi /etc/systemd/system/http.service.d/limits.conf
```
```
[Service]
LimitNOFILE=65536
LimitNPROC=65536
```
```
# systemctl daemon-reload
# systemctl restart httpd.service
```
```
### 最大FD数が変更されていることを確認
# cat /proc/`pgrep --parent 1 -f httpd`/limits | grep 'open files'
```