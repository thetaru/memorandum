# コンテナの起動
## Syntax
```
# docker container start [option] container-id [container-id]
```
|オプション|意味|
|:---|:---|
|--attach, -a|標準出力/標準エラー出力を開く|
|--interactive, -i|コンテナの標準入力を開く|
### e.g.
#### Dockerコンテナ開始
```
# docker container ls -a
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                          PORTS               NAMES
3878be285b91        centos              "/bin/bash"         43 minutes ago      Exited (0) About a minute ago                       clever_wiles
```
```
# docker container start clever_wiles
```
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
3878be285b91        centos              "/bin/bash"         44 minutes ago      Up 11 seconds                           clever_wiles
```
