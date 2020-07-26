# ネットワークへの接続
## Syntax
```
# docker network connect [option] network container
```
|オプション|意味|
|:---|:---|
|--ip|IPv4アドレス|
|--ipv6|IPv6アドレス|
|--alias|エイリアス名|
|--link|他のコンテナへのリンク|
### e.g.
#### ネットワークへの接続
```
# docker network connect test-network clever_wiles
```
```
# docker container inspect clever_wiles
```
```
...
                "test-network": {
                    "IPAMConfig": {},
                    "Links": null,
                    "Aliases": [
                        "55815d33a8a0"
                    ],
                    "NetworkID": "7651abdce1fb805c122a5301d7cf775ffc94e4d38a29c98a04ead733e8f873ed",
                    "EndpointID": "4c2586059cb1314eb209d5ff28601c81863024a7ba5979e6a9f00849e8f4045a",
                    "Gateway": "172.18.0.1",
                    "IPAddress": "172.18.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:12:00:02",
                    "DriverOpts": {}
                }
...
```
