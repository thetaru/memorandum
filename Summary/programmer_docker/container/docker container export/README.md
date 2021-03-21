# コンテナをtarファイル出力
## Syntax
```
# docker container export container-id
```
## e.g.
### tarファイル出力
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         6 hours ago         Up 6 hours                              clever_wiles
```
```
# docker container export clever_wiles > test.tar
```
```
# ll | grep test.tar
```
```
-rw-r--r--  1 root root 222576128  7月 26 21:21 test.tar
```
