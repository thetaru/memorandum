# コンテナの名前変更
## Syntax
```
# docker container rename container-id new_name
```
## e.g.
### コンテナの名前変更
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         6 hours ago         Up 6 hours                              clever_wiles
```
```
# docker container rename clever_wiles clever_animal
```
```
# docker container ls
```
```
[root@docker-test ~]# docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         6 hours ago         Up 6 hours                              clever_animal
```
