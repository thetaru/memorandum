# 稼働コンテナでプロセス実行
```
# docker container exec [option] container-id exec-command [argument]
```
## Syntax
|オプション|説明|
|:---|:---|
|--detach, -d|コマンドをバックアップで実行する|
|--interactive, -i|コンテナの標準出力を開く|
|--tty, -t|tty(端末デバイス)を使う|
|--user, -u|ユーザ名を指定する|

## e.g.
### コンテナでのbash実行
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         5 hours ago         Up 5 hours                              clever_wiles
```
```
### コンテナに入る
# docker container exec -it clever_wiles /bin/bash
```
```
[root@55815d33a8a0 /]#
```
### コンテナでのecho実行
```
# docker container exec -it clever_wiles /bin/echo "Hello World"
```
```
Hello World
```
