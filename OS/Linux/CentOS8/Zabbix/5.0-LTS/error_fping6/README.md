# icmppingが失敗する(fping6)
## ■ エラー内容
```
/usr/sbin/fping6: can't create raw socket (must run as root?) : Address family not supported by protocol
```
ipv6無効にしているのにfping6でping飛ばしにかかっているから生じるエラーっぽい。  
fping6のバグ?(バージョン上げると正常動作するっぽい)
## ■ 設定
サイテーな回避方法。  
fpingとパス同じにしちゃえ。
```
# vi /etc/zabbix/zabbix-server.conf
```
```
-  #Fping6Location=/usr/sbin/fping6
+  Fping6Location=/usr/sbin/fping
```
WebUIをみると上手くいっていたけど...これはあり...?
