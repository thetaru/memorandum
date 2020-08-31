# NFS
|ホスト名|IPアドレス|プロンプト|
|:---|:---|:---|
|kube-master|192.168.137.100|[$, [kube-master]$|
|kube-node1|192.168.137.101|$, [kube-node]$|
|kube-node2|192.168.137.102|$, [kube-node]$|
|kube-nfs|192.168.137.200|$, [kube-nfs]$|
```
[kube-node]$ sudo apt-get install nfs-common

### いらないかも?
[kube-node]$ sudo apt-get install rpcbind
```
