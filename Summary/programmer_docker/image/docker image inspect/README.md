# イメージの詳細確認
イメージの詳細情報を表示します。  
出力はJSON形式です。
## Syntax
```
# docker image inspect [option] docker-image[:tag]
```
## e.g.
### イメージの詳細表示
```
# docker image inspect --format="{{ .Os}}" ubuntu:latest
```
```
linux
```
