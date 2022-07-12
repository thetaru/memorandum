# rootアカウントロックされたときの対応
## SSOユーザのパスワードがわかる場合
以下のコマンドでシェルにはいる
```
shell.set --enable true
shell
```

## ロック解除
```
# ログイン履歴確認
pam_tally2 --user root

# ロック解除
pammtally2 --user root --reset
```
