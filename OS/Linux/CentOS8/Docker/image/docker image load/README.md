# イメージの読み込み
## Syntax
```
# docker image load [option]
```
## e.g.
### イメージ読み込み
`export.tar`は`docker image save`で作成したものとします。
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```
```
# docker image load -i export.tar
```
```
eb29745b8228: Loading layer [==================================================>]  222.6MB/222.6MB
2e32b65d7776: Loading layer [==================================================>]   2.56kB/2.56kB
Loaded image ID: sha256:5a7d6be0d395dd243097b785891f5ffc5edbbf78ef2073274537e9543666d78f
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              5a7d6be0d395        10 hours ago        215MB
```
`REPOSITORY`も`TAG`も付いていないことがわかります。
