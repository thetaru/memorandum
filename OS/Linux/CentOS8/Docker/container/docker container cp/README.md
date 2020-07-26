# コンテナ内のファイルをコピー
## Syntax
```
# docker container cp container-id:container-file_path host-directory_path
```
```
# docker container cp host-file_path container-id:container-file_path
```
## e.g.
### コンテナからホストへのファイルコピー
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
55815d33a8a0        centos              "/bin/bash"         6 hours ago         Up 6 hours                              clever_wiles
```
```
# docker container cp clever_wiles:/etc/hosts .
```
```
# ll | grep hosts
```
```
-rw-r--r--  1 root root       150  7月 26 19:28 hosts
```
### ホストからコンテナへのファイルコピー
```
# cat test.txt
```
```
hoge
fuga
piyo
```
```
# docker container cp ./test.txt clever_wiles:/tmp/test1.txt
```
```
[root@55815d33a8a0 /]# cat /tmp/test1.txt
```
```
hoge
fuga
piyo
```
