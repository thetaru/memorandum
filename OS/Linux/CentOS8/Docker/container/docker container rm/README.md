# コンテナの削除
## Syntax
```
# docker container rm [option] container-id [container-id]
```
|オプション|意味|
|:---|:---|
|--force, -f|起動中のコンテナを強制的に削除する|
|--volume, -v|割り当てたボリュームを削除する|
### e.g.
#### コンテナ削除
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
3878be285b91        centos              "/bin/bash"         54 minutes ago      Exited (0) 14 seconds ago                       clever_wiles
```
```
# docker container rm 3878be285b91
```
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
```
