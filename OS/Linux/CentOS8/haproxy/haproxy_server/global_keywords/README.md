# global
## ■ Process management and security
### ● chroot
#### Syntax
```
chroot <jail dir>
```

### ● daemon
#### Syntax
```
daemon
```

### ● group
#### Syntax
```
group <group name>
```

### ● log
#### Syntax
```
log <address> [len <length>] [format <format>] <facility> [max level [min level]]
```

### ● nbproc
#### Syntax
```
nbproc <number>
```
### ● nbthread
#### Syntax
```
nbthread <number>
```

### ● pidfile
#### Syntax
```
pidfile <pidfile>
```

### ● stats
#### Syntax
```
stats socket [<address:port>|<path>] [param*]
```

### ● user
#### Syntax
```
user <user name>
```

## ■ Performance tuning
### ● maxconn
#### Syntax
```
maxconn <number>
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
