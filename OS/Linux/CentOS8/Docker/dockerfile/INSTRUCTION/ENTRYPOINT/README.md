# デーモンの実行
`ENTRYPOINT`命令で指定されたコマンドは、DockerfileからビルドしたイメージからDockerコンテナを起動するので、`docker container run`コマンドを実行したときに実行されます。
## Syntax
```
ENTRYPOINT [exec command]
```
### ENTRYPOINT命令の2通りの記述方法
#### 1. Exec形式での記述
```
ENTRYPOINT ["nginx", "-g", "daemon off;"]
```
#### 2. Shell形式での記述
```
ENTRYPOINT nginx -g 'daemon off;'
```
## e.g.
### ENTRYPOINT命令とCMD命令の組み合わせ
```
# cat Dockerfile
```
```
# base image
FROM ubuntu:latest

# topの実行
ENTRYPOINT ["top"]
CMD ["-d", "10"]
```
