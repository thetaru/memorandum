# tarファイルからイメージ作成
## Syntax
```
# docker image import file|url - [docker-image[:tag]]
```
## e.g.
### イメージ作成
`test.tar`は`docker container export`で作成したものとします。
```
# cat test.tar | docker image import - test-image2:2.0
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
test-image2         2.0                 6e7a947a85e0        4 seconds ago       215MB
```
