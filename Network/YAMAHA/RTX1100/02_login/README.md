# ログイン設定
## ■ ログインユーザの作成
SSH用のログインユーザを作成する。
```
### ユーザの作成
# login user <user>

### ユーザの削除
# no login user <user>
```

## ■ SSHの設定
### 秘密鍵の生成
SSHサービスが有効にするために秘密鍵の生成が必須となる。
```
# sshd host key generate
```
### SSHサービスの設定
以下のコマンドでSSHサービスを`on`で有効化、`off`で無効化することができる。
```
# sshd service (on|off)
```
