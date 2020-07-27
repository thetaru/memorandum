# デーモンの実行
## Syntax
```
CMD [exec command]
```
### CMD命令の3通りの記述方法
#### 1. Exec形式での記述
シェルを介さずに実行します。
```
CMD ["nginx", "-g", "daemon off;"]
```
#### 2. Shell形式での記述
シェルを介して実行します。
```
CMD nginx -g 'daemon off;'
```
#### 3. ENTRYPOINT命令のパラメータでの記述
ENTRYPOINT命令の引数としてCMD命令を使うことができます。
## e.g.
### CMD命令の例
```
# cat Dockerfile
```
```
# base image
FROM ubuntu:latest

# Nginx install
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install nginx

# ポート指定
EXPOSE 80

# サーバ実行
CMD ["nginx", "-g", "daemon off;"]
```
```
# docker build -t cmd-sample .
```
```
Sending build context to Docker daemon  2.048kB
Step 1/5 : FROM ubuntu:latest
latest: Pulling from library/ubuntu
...
Successfully built 1e010bf778dd
Successfully tagged cmd-sample:latest
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
cmd-sample          latest              1e010bf778dd        58 seconds ago      158MB
ubuntu              latest              1e4467b07108        2 days ago          73.9MB
```
