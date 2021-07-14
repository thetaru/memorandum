# global
## ■ パラメータ
### ● log
#### Syntax
```
```
### ● chroot
#### Syntax
```
```
### ● pidfile
#### Syntax
```
```
### ● maxconn
#### Syntax
```
```
### ● user
#### Syntax
```
```
### ● group
#### Syntax
```
```
### ● daemon
#### Syntax
```
```
### ● stats
#### Syntax
```
```

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
    stats      socket /var/lib/haproxy/stats
```
