# Linux
## ■ About Notation
## COMMAND
コマンドプロンプトを使用する際は次のように記載します。  
また`#`はユーザが`root`、`$`はユーザがroot以外であることを意味します。  
なおコメントアウトは`###`始まりとします。
```
### これはコメントです
# echo 'これはrootです'
$ echo 'これはuserです'
```
## CONFIG
コンフィグの内容を変更する際は次のように記載します。
文頭`-`は**更新前**を表し、文頭`+`は**更新後**を表します。
```
-   hoge=0
+   hoge=1
=   fuga=2
```  
`-`のみの場合は**削除**を意味します。
```
-   fuga=0
```
`+`のみの場合は**追加**を意味します。
```
+   piyo=1
```
`=`は変更はしないが存在することを**強調**することを意味します。
```
=  fuga=2
```
## ■ OS
- [ ] [CentOS8](CentOS8)
- [ ] [CentOS9](CentOS9)
- [ ] [RHEL7](RHEL7)
- [ ] [RHEL8](RHEL8)
- [ ] [Ubuntu Server 20.04](Ubuntu_Server_20.04)
- [ ] [Ubuntu Server 22.04](Ubuntu_Server_22.04)

