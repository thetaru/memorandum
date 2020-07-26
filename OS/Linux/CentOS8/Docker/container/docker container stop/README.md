# コンテナの停止
## Syntax
```
# docker container stop [option] container-id [container-id]
```
|オプション|意味|
|:---|:---|
|--time, -t|コンテナの停止時間を指定する(指定秒数後に停止)|
### e.g.
#### コンテナ停止
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3878be285b91        centos              "/bin/bash"         44 minutes ago      Up 11 seconds                           clever_wiles
```
```
# docker container stop clever_wiles
```
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
3878be285b91        centos              "/bin/bash"         47 minutes ago      Exited (0) 15 seconds ago                       clever_wiles
```
