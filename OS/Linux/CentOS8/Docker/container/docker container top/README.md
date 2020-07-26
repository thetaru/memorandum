# 稼働コンテナのプロセス確認
## Syntax
```
# docker container top container-id
```
### e.g.
#### プロセス確認
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         6 hours ago         Up 6 hours                              clever_wiles
```
```
# docker container top clever_wiles
```
```
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                9324                9308                0                   14:54               ?                   00:00:00            /bin/bash
```
