# syslog設定
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

if (re_match($fromhost-ip, '^xxx\\.xxx\\.xxx\\.()$'))
```
# クライアント側の設定
## rsyslogの設定
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
## 送信元ホスト名の指定
ホスト名のみ`$LocalHostName {{HOSTNAME}}`, FQDN`$ PreserveFQDN on`
