# syslogサーバ設定
https://www.server-world.info/query?os=CentOS_8&p=rsyslog&f=2  
https://sig9.hatenablog.com/entry/2019/10/08/000000
## ■ サーバー側の設定
## ■ クライアント側の設定
```
# vi /etc/rsyslog.d/Send_To_Server.conf
```
```
### UDP
*.*    @<Syslog Serverのホスト名 or IPアドレス>[:<Port>]
```
