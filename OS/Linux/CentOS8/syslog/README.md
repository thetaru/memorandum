# syslogサーバ設定
https://www.server-world.info/query?os=CentOS_8&p=rsyslog&f=2  
https://sig9.hatenablog.com/entry/2019/10/08/000000
## ■ サーバー側の設定
```
# vi /etc/rsyslog.d/assign.conf
```
```
### 振り分け先テンプレート(テンプレート名:test)
$template test,"/logs/%hostname%/messages"

### IPアドレスのフィルタリング
if $fromhost-ip == ['xxx.xxx.xxx.xxx', 'yyy.yyy.yyy.yyy'] then {
    -?test
    stop
}
```
## ■ クライアント側の設定
```
# vi /etc/rsyslog.d/Send_To_Server.conf
```
### UDPの場合
```
*.*    @<Syslog Serverのホスト名 or IPアドレス>[:<Port>]
```
### TCPの場合
```
*.*    @@<Syslog Serverのホスト名 or IPアドレス>[:<Port>]
```
