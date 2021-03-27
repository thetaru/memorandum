# Kubernetes最初の一歩
## 6.1 クラスタ構成の確認
k8sクラスタが起動したら構成を確認します。  
手元の環境だと次のように出力されました。
```
kube-master:~/# kubectl cluster-info
```
```
Kubernetes control plane is running at https://192.168.137.5:6443
KubeDNS is running at https://192.168.137.5:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
```
kube-master:~/# kubectl get node
```
```
NAME          STATUS   ROLES                  AGE   VERSION
kube-master   Ready    control-plane,master   13d   v1.20.4
kube-node01   Ready    <none>                 13d   v1.20.4
kube-node02   Ready    <none>                 13d   v1.20.4
```
k8sクラスタの稼働を確認できたら次に進みます。
## 6.2 ポッドの実行
ポッドはk8sにおけるコンテナの最小実行単位です。  
k8sでhello-worldコンテナを実行してみます。
```
kube-master:~/# kubectl run hello-world --image=hello-world -it --restart=Never
```
```

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

```
もう一度ポッドとしてコンテナを起動してみると(既にポッドが存在するため)エラーが出力されます。  
```
kube-master:~/# kubectl run hello-world --image=hello-world -it --restart=Never
```
```
Error from server (AlreadyExists): pods "hello-world" already exists
```
というわけでポッドの一覧を見てみましょう。
```
kube-master:~/# kubectl get pod
```
```
NAME          READY   STATUS      RESTARTS   AGE
hello-world   0/1     Completed   0          5m8s
```
終了した(Completed)ポッドが残っていることがわかります。  
それではポッドを削除して、もう一度実行できることを確認しましょう。
```
kube-master:~/# kubectl delete pod hello-world
```
```
pod "hello-world" deleted
```
```
kube-master:~/# kubectl get pod
```
```
kube-master:~/# kubectl run hello-world --image=hello-world -it --restart=Never
```
