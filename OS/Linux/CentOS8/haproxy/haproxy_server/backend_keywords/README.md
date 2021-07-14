# backend
## ■ パラメータ
### ● balance
#### Syntax
```
```

### ● server
#### Syntax
```
```

## ■ 設定例
```
backend app
   balance     roundrobin
   server  app1 192.168.1.1:80 check
   server  app2 192.168.1.2:80 check
   server  app3 192.168.1.3:80 check inter 2s rise 4 fall 3
   server  app4 192.168.1.4:80 backup
```
