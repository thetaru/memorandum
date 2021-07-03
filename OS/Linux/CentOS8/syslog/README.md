# rsyslog設定
## ■ Settings
- [ ] [syslogサーバの構築](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/syslog/syslog_server)
- [ ] [syslogクライアントの構築]()
## ■ Tips

:warning:書きかけ  
https://www.server-world.info/query?os=CentOS_8&p=rsyslog&f=2  
https://sig9.hatenablog.com/entry/2019/10/08/000000
# サーバー側の設定
## rsyslogの設定
```
# vi /etc/rsyslog.d/filter.conf
```
```
### 振り分け先テンプレート(テンプレート名:test)
template(name="test" type="string" string="string="/var/log/syslog/%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%/messages.log")

### IPアドレスのフィルタリング例
if $fromhost-ip == ['xxx.xxx.xxx.xxx', 'yyy.yyy.yyy.yyy'] then {
    *.info;mail.none;authpriv.none;cron.none ?test
}

if (re_match($fromhost-ip, '^xxx\\.xxx\\.xxx\\.([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])$')) then {
    *.info;mail.none;authpriv.none;cron.none ?test
}
```
# クライアント側の設定
## rsyslogの設定
```
# vi /etc/rsyslog.d/Send_To_Server.conf
```
### ログ転送(UDPの場合)
```
### 旧
*.*    @<Syslog Serverのホスト名 or IPアドレス>[:<Port>]

### 新
action(type="omfwd" Port="<Port>" Protocol="udp" Target="<SyslogサーバのIPアドレス>")
```
### ログ転送(TCPの場合)
```
### 旧
*.*    @@<Syslog Serverのホスト名 or IPアドレス>[:<Port>]

### 新
action(type="omfwd" Port="<Port>" Protocol="tcp" Target="<SyslogサーバのIPアドレス>")
```
## 送信元ホスト名の指定

|設定|表示|
|:---|:---|
|$LocalHostName {{HOSTNAME}}|ホスト名|
|$PreserveFQDN on|FQDN|

