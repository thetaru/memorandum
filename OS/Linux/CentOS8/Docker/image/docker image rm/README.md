# イメージの削除。
## Syntax
```
# docker image rm [option] docker-image [docker-image]
```
※ docker-imageには `REPOSITORY` または `IMAGE ID`を指定します。
|オプション|意味|
|:---|:---|
|--force, -f|イメージを強制的に削除する|
|--no-prun|中間イメージを削除しない|
## e.g.
### イメージの削除
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              1e4467b07108        37 hours ago        73.9MB
centos              latest              831691599b88        5 weeks ago         215MB
```
```
# docker image rm ubuntu
```
```
Untagged: ubuntu:latest
Untagged: ubuntu@sha256:5d1d5407f353843ecf8b16524bc5565aa332e9e6a1297c73a92d3e754b8a636d
Deleted: sha256:1e4467b07108685c38297025797890f0492c4ec509212e2e4b4822d367fe6bc8
Deleted: sha256:7515ee845913c8df9826c988341a09e0240e291c66bdc436a067e070d7910a1f
Deleted: sha256:50ebe6a0675f1ed7ca499a2ec7d8cc993d495dd66ca1035c218ec5efcb6fbb8c
Deleted: sha256:2515e0ecfb82d58c004c4b53fcf9230d9eca8d0f5f823c20172be01eec587ccb
Deleted: sha256:ce30112909569cead47eac188789d0cf95924b166405aa4b71fb500d6e4ae08d
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
centos              latest              831691599b88        5 weeks ago         215MB
```
