# global
## ■ パラメータ
### ● log
### ● maxconn
### ● user
### ● group
### ● daemon

## ■ 設定例
```
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
```
