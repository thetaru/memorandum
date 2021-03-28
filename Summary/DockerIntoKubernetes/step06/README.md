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
## 6.2.1 hello-worldポッドの実行
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
## 6.2.2 hello-worldポッドの再実行
もう一度ポッドを起動してみると(既にポッドが存在するため)エラーが出力されます。  
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
  
それではポッドを削除して、もう一度実行できることを確認します。
```
### ポッドの削除
kube-master:~/# kubectl delete pod hello-world
```
```
pod "hello-world" deleted
```
```
### ポッドの表示
kube-master:~/# kubectl get pod
```
```
No resources found in default namespace.
```
```
### ポッドの実行
kube-master:~/# kubectl run hello-world --image=hello-world -it --restart=Never
```
```

Hello from Docker!
This message shows that your installation appears to be working correctly.
<以下省略>
```
## 6.2.3 ポッドの自動削除
終了したポッドを自動削除するオプション`--rm`があります。(実行済みのhello-worldポッドは削除してください。)
```
kube-master:~/# kubectl run hello-world --image=hello-world -it --restart=Never --rm
```
```

Hello from Docker!
This message shows that your installation appears to be working correctly.
<以下省略>
pod "hello-world" deleted
```
## 6.2.4 ポッドのバックグラウンド実行とログ表示
`-it`オプションを省略してポッドを実行すると、バックグランドで実行されます。
```
kube-master:~/# kubectl run hello-world --image=hello-world --restart=Never
```
```
pod/hello-world created
```
ポッドのコンテナが実行中に出力した内容は、標準出力に書き出させログとして保存されます。  
ログは`kubectl logs <ポッド名>`で確認します。
```
kube-master:~/# kubectl logs hello-world
```
```

Hello from Docker!
This message shows that your installation appears to be working correctly.
<以下省略>
```
## 6.3 コントラーラによるポッドの実行
## 6.3.1 kubectlによるデプロイメントの実行
`kubectl run`のオプションを変更することにより、ポッドをデプロイメントコントローラの制御化で実行することもできます。  
ポッドが停止したときに再スタートするようになります。
```
kube-master:~/# kubectl create deployment --image hello-world hello-world
```
```
deployment.apps/hello-world created
```
## 6.3.2 デプロイメントの実行状態のリスト表示
次にデプロイメントが作成するオブジェクトのすべてを表示します。
```
kube-master:~/# kubectl get all
```
```
NAME                              READY   STATUS             RESTARTS   AGE
pod/hello-world-d758f5675-57dgf   0/1     CrashLoopBackOff   2          80s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   13d

NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/hello-world   0/1     1            0           81s

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/hello-world-d758f5675   1         1         0       81s
```
## 6.3.3 ポッドのログ出力
コンテナのメッセージ出力は、`kubectl logs <ポッド名>`で取得できます。  
上で作成したポッドのログを出力してみます。
```
kube-master:~/# pod/hello-world-d758f5675-57dgf
```
## 6.3.4 デプロイメントの削除
デプロイメントの削除は、`kubectl delete deployment <オブジェクト名>`で実施できます。
```
### オブジェクト名の確認
kube-master:~/# kubectl get deployment
```
```
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
hello-world   0/1     1            0           18m
```
```
### デプロイメントの削除
kube-master:~/# kubectl delete deployment hello-world
```
```
deployment.apps "hello-world" deleted
```
## 6.3.5 Nginxのデプロイメント
5個のNginxのポッドを起動します。  
仮にポッドの一つがクラッシュしても、デプロイメントは稼働数5を維持するようにポッド数を制御します。
```
kube-master:~/# kubectl create deployment --image=nginx webserver
kube-master:~/# kubectl scale deployment --replicas=2 webserver
```
