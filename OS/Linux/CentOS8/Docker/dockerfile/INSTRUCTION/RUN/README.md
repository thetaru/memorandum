# コマンドの実行
## Syntax
```
RUN [exec command]
```
### RUN命令の2通りの記述方法
#### 1. Shell形式での記述
```
# Nginxのインストール
RUN apt-get install -y nginx
```
#### 2. Exec形式での記述
```
# Nginxのインストール
RUN ["/bin/bash", "-c", "apt-get install -y nginx"]
```
## e.g.
### RUN命令の実行ログ
```
# cat dockerfile
```
```
FROM ubuntu:latest

RUN echo Shell形式
RUN ["echo", "Exec形式"]
RUN ["/bin/bash", "-c", "echo 'Exec形式 on bash'"]
```
```
# docker build -t run-sample .
```
```
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM ubuntu:latest
latest: Pulling from library/ubuntu
3ff22d22a855: Pull complete
e7cb79d19722: Pull complete
323d0d660b6a: Pull complete
b7f616834fd0: Pull complete
Digest: sha256:5d1d5407f353843ecf8b16524bc5565aa332e9e6a1297c73a92d3e754b8a636d
Status: Downloaded newer image for ubuntu:latest
 ---> 1e4467b07108
Step 2/4 : RUN echo Shell形式
 ---> Running in 838160426a44
Shell形式
Removing intermediate container 838160426a44
 ---> 313bc4c5c985
Step 3/4 : RUN ["echo", "Exec形式"]
 ---> Running in ec6d3c838ad9
Exec形式
Removing intermediate container ec6d3c838ad9
 ---> 770e9c855f01
Step 4/4 : RUN ["/bin/bash", "-c", "echo 'Exec形式 on bash'"]
 ---> Running in 115c0e8ad722
Exec形式 on bash
Removing intermediate container 115c0e8ad722
 ---> fbee10d1e86c
Successfully built fbee10d1e86c
Successfully tagged run-sample:latest
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
run-sample          latest              fbee10d1e86c        3 minutes ago       73.9MB
ubuntu              latest              1e4467b07108        2 days ago          73.9MB
```
ダウンロードされた`ubuntu`イメージと生成された`run-sample'イメージがあります。
