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
```
# docker network disconnect network container
```
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
#### ネットワークを指定したコンテナの起動
```
# docker container run -itd --name=test-container --net=test-network centos
```
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
d67a5987ea0b        centos              "/bin/bash"         15 seconds ago      Up 14 seconds                           test-container
```
```
# docker container inspect test-container
```
```
                "test-network": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "d67a5987ea0b"
                    ],
                    "NetworkID": "7651abdce1fb805c122a5301d7cf775ffc94e4d38a29c98a04ead733e8f873ed",
                    "EndpointID": "3ec27aabf7af3d361b4577a68e4af6270c20371b76b0cecdaad55fbd542197c6",
                    "Gateway": "172.18.0.1",
                    "IPAddress": "172.18.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:12:00:03",
                    "DriverOpts": null
                }
```
#### ネットワークの切断
```
# docker container ls
```
```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
d67a5987ea0b        centos              "/bin/bash"         2 minutes ago       Up 2 minutes                            test-container
```
```
# docker container inspect test-container
```
```
                "test-network": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": [
                        "d67a5987ea0b"
                    ],
                    "NetworkID": "7651abdce1fb805c122a5301d7cf775ffc94e4d38a29c98a04ead733e8f873ed",
                    "EndpointID": "3ec27aabf7af3d361b4577a68e4af6270c20371b76b0cecdaad55fbd542197c6",
                    "Gateway": "172.18.0.1",
                    "IPAddress": "172.18.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:12:00:03",
                    "DriverOpts": null
                }
```
```
# docker network disconnect test-network test-container
```
```
...
"Networks": {}
...
```
