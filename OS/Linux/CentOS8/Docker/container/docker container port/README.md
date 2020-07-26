# 稼働コンテナのポート転送確認
## Syntax
```
# docker container port container-id
```
## e.g.
### コンテナのポート転送
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                NAMES
b833f01386f0        centos              "/bin/bash"         25 seconds ago      Up 4 seconds        0.0.0.0:80->80/tcp   relaxed_lalande
```
```
# docker container port relaxed_lalande
```
```
80/tcp -> 0.0.0.0:80
```
