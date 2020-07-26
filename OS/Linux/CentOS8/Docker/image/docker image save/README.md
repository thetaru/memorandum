# イメージの保存
## Syntax
```
# docker image save [option] save-file [docker-image]
```
## e.g.
### イメージ保存
イメージを`export.tar`ファイルとして保存します。
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
centos              latest              831691599b88        5 weeks ago         215MB
```
```
# docker image save -o export.tar centos
```
```
# ll | grep export.tar
```
```
-rw-------  1 root root 222588416  7月 26 11:54 export.tar
```
