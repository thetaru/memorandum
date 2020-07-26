# コンテナの稼働確認
## Syntax
```
# docker container stats [container-id]
```
### e.g.
#### コンテナ稼働確認
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3878be285b91        centos              "/bin/bash"         39 minutes ago      Up 39 minutes                           clever_wiles
```
```
# docker container stats clever_wiles
```
```
CONTAINER ID        NAME                CPU %               MEM USAGE / LIMIT     MEM %               NET I/O             BLOCK I/O           PIDS
3878be285b91        clever_wiles        0.00%               1.074MiB / 1.721GiB   0.06%               1.62kB / 0B         0B / 0B             1
```
