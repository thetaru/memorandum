# memo
## Hostname
```
set system host-name <hostname>
```
## Set/change the password of a user
```
set system login user [username] authentication plaintext-password [password]
```

## Default Gateway/Route
set
```
set protocols static route 0.0.0.0/0 next-hop <address> 
```
del
```
delete protocols static route 0.0.0.0/0
```
