# docker system df
Dockerが使用しているディスクの使用状況を表示します。  
```-v```を付けると詳細表示になります。
## Syntax
```
# docker system df [-v]
```
### e.g.
```
# docker system df
```
```
TYPE                TOTAL               ACTIVE              SIZE                RECLAIMABLE
Images              2                   2                   206.3MB             0B (0%)
Containers          2                   1                   1.116kB             0B (0%)
Local Volumes       0                   0                   0B                  0B
Build Cache         0                   0                   0B                  0B
```
