# コンテナからイメージ作成
## Syntax
```
# docker container commit [option] container-id [docker-image[:tag]]
```
|オプション|意味|
|:---|:---|
|--author, -a|作成者を指定する|
|--message, -m|メッセージを指定する|
|--change, -c|コミット時のDockerfile命令を指定|
|--pause, -p|コンテナを一時停止してコミットする|
## e.g.
### コンテナからイメージを作成
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         6 hours ago         Up 6 hours                              clever_wiles
```
```
# docker container commit -a "thetaru" clever_wiles test-image:1.0
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
test-image          1.0                 d5db6715520c        7 seconds ago       215MB
```
