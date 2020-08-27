# ローカルアカウント追加
# 手順
## vCenterにアクセス
teraterm等でsshします。
## コマンド
```
Command> localaccounts.user.add --role <role> --username <username> --password
```
```
Enter Password:
```
|ロール|役割|
|:---|:---|
|operator||
|admin|システム管理者|
|superAdmin||
