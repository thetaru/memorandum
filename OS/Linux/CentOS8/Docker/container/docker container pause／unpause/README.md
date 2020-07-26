# コンテナの中断/再開
## Syntax
コンテナの中断
```
# docker container pause container-id
```
コンテナの再開
```
# docker container unpause container-id
```
## e.g.
### コンテナの中断
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         2 minutes ago       Up About a minute                       clever_wiles
```
```
# docker container pause clever_wiles
```
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                  PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         3 minutes ago       Up 2 minutes (Paused)                       clever_wiles
```
### コンテナの再開
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                  PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         3 minutes ago       Up 2 minutes (Paused)                       clever_wiles
```
```
# docker container unpause clever_wiles
```
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         4 minutes ago       Up 3 minutes                            clever_wiles
```
