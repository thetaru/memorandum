# メモ
## ポッドの実行
```
$ kubectl run <object-name> --image=<image-name> -it --restart=<option>
```
## ポッドの表示
```
$ kubectl get node
```
## ポッドの削除
```
$ kubectl delete pod <object-name>
```
## デプロイメントの実行(Always)
podをデプロイメントコントローラー下で実行すること。
```
$ kubectl create deployment --image=<image-name> <object-name>
```
```
$ kubectl get deploy,po
```
```
$ kubectl delete deployment <object-name>
```
```
### 複数台のポッドを起動
$ kubectl create deployment --image=<image-name> <object-name>
$ kubectl scale --replicas=<number of pod> deployment/<object-name>
```
```
### 複数台でも削除の仕方は同じ
$ kubectl delete deployment <object-name>
```
## ジョブによるポッドの実行(OnFailure)
```
$ kubectl create job <object-name> --image=<image-name>
```


# サービス
## NodePort
```
$ kubectl apply -f deploy.yml
$ kubectl apply -f service-np.yml
$ kubectl get svc
```
```
NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
web-service-np   NodePort    10.99.136.249   <none>        80:31087/TCP   30m
```
```
$ ip a
```
```
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:d9:61:0c brd ff:ff:ff:ff:ff:ff
    inet 192.168.137.100/24 brd 192.168.137.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fed9:610c/64 scope link
       valid_lft forever preferred_lft forever
```
ブラウザから`192.168.137.100:31087`へアクセスする。

## LoadBalancer
```
$ kubectl apply -f deploy.yml
$ kubectl apply -f service-lb.yml
$ kubectl get svc
```
```
NAME          TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
web-service   LoadBalancer   10.109.48.150   <pending>     80:31979/TCP   5m1s
```
```
$ kubectl describe svc web-service
```
```
Name:                     web-service
Namespace:                default
Labels:                   <none>
Annotations:              Selector:  app=web
Type:                     LoadBalancer
IP:                       10.109.48.150
Port:                     webserver  80/TCP
TargetPort:               80/TCP
NodePort:                 webserver  31979/TCP
Endpoints:                10.244.1.54:80,10.244.1.55:80,10.244.2.45:80 <- これらでロードバランスする
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```
```
$ ip a
```
```
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:d9:61:0c brd ff:ff:ff:ff:ff:ff
    inet 192.168.137.100/24 brd 192.168.137.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fed9:610c/64 scope link
       valid_lft forever preferred_lft forever
```
ブラウザから`192.168.137.100:31979`へアクセスする。
