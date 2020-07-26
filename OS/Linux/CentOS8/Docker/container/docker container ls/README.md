# 稼働コンテナの一覧表示
## Syntax
```
# docker container ls [option]
```
|オプション|意味|
|:---|:---|
|-all, -a|起動中/停止中も含めてすべてのコンテナを表示する|
### e.g.
#### コンテナ一覧表示
```
# docker container ls
```
|オプション|意味|
|:---|:---|
|CONTAINER ID|コンテナID|
|IMAGE|コンテナのもとになっているイメージ|
|COMMAND|コンテナ内で実行されているコマンド|
|CREATED|コンテナ作成からの経過時間|
|STATUS|コンテナの状態|
|PORTS|割り当てられたポート|
|NAMES|コンテナ名|
