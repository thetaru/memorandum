# memo

公開しているwebサーバの証明書を確認
```
openssl s_client -connect example.com:443 | openssl x509 -noout -enddate

openssl s_client -connect example.com:25 -starttls smtp | openssl x509 -noout -dates
openssl s_client -connect example.com:587 -starttls smtp | openssl x509 -noout -dates

openssl s_client -showcerts -connect example.org:443

openssl s_server -accept 10443 -cert example.com.crt -key example.com.key -CAfile example.com.ica -WWW
openssl s_client -connect localhost:10433
```
ハードウェアの情報を表示する(オプション使うのがよい)
```
dmidecode
```
systemdのtarget
```
systemctl get-default

# CUI
systemctl set-default multi-user.target

# GUI
systemctl set-default graphical.target
```

ps
```
ps -lC <プロセス名>
ps -lp $(pgrep <プロセス名>)

# オキに
ps -fup $(pgrep <プロセス名>)

# -oでフォーマットいじれる
ps -o user,pid,uid,tty,cmd -p $(pgrep <プロセス名>)
```

tracepath
```
tracepath [-p port] -n host
```

yum系
```
yum provides <command>
```
kill  
シグナルは必ず文字列で指定すること
```
kill -s <シグナル名> <PID>
```
標準出力と標準エラー出力を別々のファイルに出力
```
some-commnad > stdout.log 2> stderr.log
```
大きなサイズのファイルでgrepする際はファイルを分割すると楽
```
split -l 行数 ファイルパス
```

tlp バッテリ系
```
tlp-stat
tlp-stat -b
```

ファイルやソケットを掴んでいるプロセスを探す
```
fuser -v /dev/sda1
```
FC接続時に認識しているLUNをみる
```
cat /proc/scsi/scsi
```
