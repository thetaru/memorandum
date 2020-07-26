# docker image rm
作成したイメージを削除します。
## Syntax
```
# docker image rm [option] docker-image [docker-image]
```
※ docker-imageには `REPOSITORY` または `IMAGE ID`を指定します。
|オプション|意味|
|:---|:---|
|--force, -f|イメージを強制的に削除する|
|--no-prun|中間イメージを削除しない|
### e.g.
