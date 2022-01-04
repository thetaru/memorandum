# ログインしたらやること
## ホスト名の確認
```
uname -n
```
## ログインユーザの確認
```
w
```
## 現在時刻の確認
認証関係は時刻にシビアなので疑う
```
date
```
## 稼働時間の確認
OSがハングアップした形跡がないことを確認する
```
uptime
```
## プロセスの確認
```
ps auxf
ps -fup $(pgrep <proc-name>)
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
リッスンポートの確認
```
ss -antl
ss -anul
```
```
free -m
```
```
top
```
```
iostat -x 5s
```
## ログの確認
```
# ログファイル
less /var/log/messages
less /var/log/cron
less /var/log/secure

# カーネル
dmesg -kxT [-l <priority>]
```
SELinux環境ならauditログも確認する
```
ausearch -m avc -ts today
```
## コアダンプの確認
コアファイルがないことを確認する
```
coredumpctl list
```
