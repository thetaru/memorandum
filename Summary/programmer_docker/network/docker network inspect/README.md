# ネットワークの詳細確認
## Syntax
```
# docker network inspect [option] network
```
## e.g.
### ネットワークの詳細表示
```
# docker network ls
```
```
NETWORK ID          NAME                DRIVER              SCOPE
7651abdce1fb        test-network        bridge              local
```
```
# docker network inspect test-network
```
```
[
    {
        "Name": "test-network",
        "Id": "7651abdce1fb805c122a5301d7cf775ffc94e4d38a29c98a04ead733e8f873ed",
        "Created": "2020-07-26T19:00:50.652144+09:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "55815d33a8a00b0ce01dfa71c7b10aafb5bc1b90a124e84195f834ef9fa9a22e": {
                "Name": "clever_wiles",
                "EndpointID": "4c2586059cb1314eb209d5ff28601c81863024a7ba5979e6a9f00849e8f4045a",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```
