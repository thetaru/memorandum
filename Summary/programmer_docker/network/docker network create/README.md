# ネットワークの作成
## Syntax
```
# docker network create [option] network
```
|オプション|意味|
|:---|:---|
|--driver, -d|ネットワークブリッジまたはオーバーレイ(デフォルトはbridge)|
|--ip-range|コンテナに割り当てるIPアドレスのレンジを指定|
|--subnet|サブネットをCIDR形式で指定|
|--ipv6|IPv6ネットワークを有効にするかどうか(true/false)|
|-label|ネットワークに設定するラベル|
## e.g.
### ブリッジネットワークの作成
```
# docker network create --driver=bridge test-network
```
```
# docker network ls
```
```
NETWORK ID          NAME                DRIVER              SCOPE
7651abdce1fb        test-network        bridge              local
```
