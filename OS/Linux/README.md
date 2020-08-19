# Linux
# ■ About Notation
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
```  
`-`のみの場合は**削除**を意味します。
```
-   fuga=0
```
`+`のみの場合は**追加**を意味します。
```
+   piyo=1
```
# ■ Contents
- [ ] [CentOS8](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8)
- [ ] [RHEL7](https://github.com/thetaru/memorandum/tree/master/OS/Linux/RHEL7)
- [ ] [Ubuntu Server 20.04](https://github.com/thetaru/memorandum/tree/master/OS/Linux/Ubuntu_Server_20.04)
