# ログインしたらやること
## ログインユーザの確認
```
w
```
## 稼働時間の確認
```
uptime
```
## プロセスの確認
```
ps auxf
ps -ufp $(pgrep <proc-name>)
```
## NICの確認
```
ip a
nmcli connection show
nmcli connection show <con-name>
```
## ファイルシステムの確認
```
df -Th
```
## 負荷の確認
```
ss -antl
ss -anul
```
```
top
```
```
iostat -x 5s
```
## ログの確認
```
less /var/log/messages
less /var/log/cron
less /var/log/secure
```
selinux環境ならauditログも確認する
```
ausearch -m avc -ts today
```
## コアダンプの確認
コアファイルがないことを確認する
```
coredumpctl list
```
