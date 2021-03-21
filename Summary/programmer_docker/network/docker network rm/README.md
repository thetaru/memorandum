# ネットワークの削除
## Syntax
```
# docker network rm [option] network
```
:warning: ネットワークの削除をするにはどのコンテナも削除対象のネットワークを使っていない必要があります。
## e.g.
### ネットワークの削除
```
# docker network ls
```
```
NETWORK ID          NAME                DRIVER              SCOPE
7651abdce1fb        test-network        bridge              local
```
```
# docker network rm test-network
```
```
# docker network ls
```
```
NETWORK ID          NAME                DRIVER              SCOPE
```
