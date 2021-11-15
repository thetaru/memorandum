# memo
ファイルで共通する行を抜き出す
```
grep -x -i -f  file1 file2
```
UID/GIDを指定したユーザー追加
```
### GID=1001のグループhogeを作成
groupadd -g 1001 hoge

### UID=1001 GID=1001のユーザーhogeを作成
useradd -u 1001 -g 1001 hoge
```
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
ps -p $(pgrep <プロセス名>)
ps -o user,pid,uid,tty,cmd -p $(pgrep <プロセス名>)
```
