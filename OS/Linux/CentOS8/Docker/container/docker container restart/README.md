# コンテナの再起動
## Syntax
```
# docker container restart [option] container-id [container-id]
```
|オプション|意味|
|:---|:---|
|--time, -t|コンテナの再起動時間を指定する(指定秒数後に再起動)|
### e.g.
#### コンテナ再起動
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3878be285b91        centos              "/bin/bash"         49 minutes ago      Up 2 seconds                            clever_wiles
```
```
# docker container restart -t 2 clever_wiles
```
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3878be285b91        centos              "/bin/bash"         50 minutes ago      Up 4 seconds                            clever_wiles
```
