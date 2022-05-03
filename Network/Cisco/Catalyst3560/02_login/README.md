# ログイン設定
## ■ SSHの設定
### ホスト名の設定
```
(config)# hostname <hostname>
```
### ドメイン名の設定
```
(config)# ip domain-name <domain>
```
### ログインユーザの作成
```
(config)# username <user> password <password>
```
### 秘密鍵の生成
```
(config)# crypto key generate rsa
```
```
How many bits in the modulus [512]: 2048
```
### SSHバージョンの指定
```
(config)# ip ssh version 2
```
### VTYの設定
```
(config)# line vty 0 4
(config-line)# login local
(config-line)# transport input ssh
(config-line)# exit
```
