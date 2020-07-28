# ユーザの指定
## Syntax
```
USER [username/UID]
```
:warning:USER命令で指定するユーザは、事前にRUN命令で作成する必要があります。
### e.g.
#### USER命令の例
```
### ユーザthetaruを作成
RUN ["useradd", "thetaru"]

### rootが出力される
RUN ["whoami"]

### ユーザthetaruに切り替え
USER thetaru

### thetaruが出力される
RUN ["whoami"]
```
