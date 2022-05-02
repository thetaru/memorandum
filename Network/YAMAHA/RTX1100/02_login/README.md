# ログイン設定
## ■ ログインユーザの作成
SSH用のログインユーザを作成する。
```
### ユーザの作成
# login user <user> <password>

### ユーザの削除
# no login user <user>
```

## ■ SSHサービスの設定
以下のコマンドでSSHサービスを`on`で有効化、`off`で無効化することができる。
```
# sshd service (on|off)
```
