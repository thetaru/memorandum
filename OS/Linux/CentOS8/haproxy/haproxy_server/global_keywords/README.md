# global
## ■ パラメータ
### ● log
### ● chroot
### ● pidfile
### ● maxconn
### ● user
### ● group
### ● daemon

## ■ 設定例
```
global
    log        127.0.0.1 local2
    chroot     /var/lib/haproxy
    pipfile    /var/run/haproxy.pid
    maxconn    4000
    user       haproxy
    group      haproxy
    daemon
```
