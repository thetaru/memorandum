# イメージのタグ設定
## Syntax
```
# docker image tag SOURCE-image[:tag] TARGET-image[:tag]
```
## e.g.
### イメージへのタグ設定
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              1e4467b07108        20 hours ago
```
```
# docker image tag ubuntu:latest hoge:1.0
```
```
# docker image ls
```
```
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hoge                1.0                 1e4467b07108        20 hours ago        73.9MB
ubuntu              latest              1e4467b07108        20 hours ago
```
hogeとubuntuの`IMAGE ID`が同じなので実体は同一です。
