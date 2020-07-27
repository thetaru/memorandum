# ビルド完了時に実行される命令
## Syntax
ONBUILD [exec command]
## e.g.
ONBUILD命令は、自身のDockerfileから生成したイメージをベースイメージとした別のDockerfileをビルドするときに実行したいコマンドを記述する。
### ベースイメージの作成
```
# cat Dockerfile.base
```
```
# base image
FROM ubuntu:latest

# Nginx install
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install nginx

# ポート指定
# EXPOSE 80

# Webコンテンツの配置
ONBUILD ADD website.tar /var/www/html/

# ngninxの実行
CMD ["nginx", "-g", "daemon"]
```
```
# docker build -t web-base -f Dockerfile.base .
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
web-base            latest              b8f2cc968540        40 seconds ago      158MB
ubuntu              latest              1e4467b07108        2 days ago          73.9MB
```
