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
```
# docker build -t sample .
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
sample              latest              402210f55703        50 seconds ago      73.9MB
ubuntu              latest              1e4467b07108        2 days ago          73.9MB
```
CMD命令で指定した10秒ごとに更新する
```
# docker container run -it sample
```
2秒ごとに更新する
```
# docker container run -it sample -d 2
```
これは、CMD命令が`docker container run`コマンド実行時に上書きできるという仕様のためです。
