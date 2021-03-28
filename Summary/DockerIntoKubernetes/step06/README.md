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
### デプロイメントを作成後にスケール
kube-master:~/# kubectl create deployment --image=nginx webserver
kube-master:~/# kubectl scale deployment --replicas=2 webserver
```
ポッドが5個作成されていることを確認します。
```
kube-master:~/# kubectl get deployment,pod
```
```
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/webserver   5/5     5            5           2m

NAME                             READY   STATUS    RESTARTS   AGE
pod/webserver-559b886555-2dbtm   1/1     Running   0          106s
pod/webserver-559b886555-bnwn7   1/1     Running   0          106s
pod/webserver-559b886555-d9fpz   1/1     Running   0          119s
pod/webserver-559b886555-qknhc   1/1     Running   0          107s
pod/webserver-559b886555-zmj8c   1/1     Running   0          106s
```
## 6.3.6 デプロイメントによるポッドの自己回復
ポッドを強制終了させても自己回復することを確認します。
```
### ポッドの削除
kube-master:~/# kubectl delete pod webserver-559b886555-2dbtm webserver-559b886555-bnwn7
```
```
pod "webserver-559b886555-2dbtm" deleted
pod "webserver-559b886555-bnwn7" deleted
```
ポッドが削除されていることが確認できます。
```
kube-master:~/# kubectl get deployment,pod
```
```
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/webserver   3/5     5            3           5m16s

NAME                             READY   STATUS              RESTARTS   AGE
pod/webserver-559b886555-d9fpz   1/1     Running             0          5m15s
pod/webserver-559b886555-dd8bh   0/1     ContainerCreating   0          28s
pod/webserver-559b886555-qknhc   1/1     Running             0          5m3s
pod/webserver-559b886555-zfnb8   0/1     ContainerCreating   0          27s
pod/webserver-559b886555-zmj8c   1/1     Running             0          5m2s
```
ポッドが自己回復していることが確認できます。
```
kube-master:~/# kubectl get deployment,pod
```
```
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/webserver   5/5     5            5           7m1s

NAME                             READY   STATUS    RESTARTS   AGE
pod/webserver-559b886555-d9fpz   1/1     Running   0          7m
pod/webserver-559b886555-dd8bh   1/1     Running   0          2m13s
pod/webserver-559b886555-qknhc   1/1     Running   0          6m48s
pod/webserver-559b886555-zfnb8   1/1     Running   0          2m12s
pod/webserver-559b886555-zmj8c   1/1     Running   0          6m47s
```
ポッド名のハッシュ文字列が変わっていることがわかります。(自己回復というより新規作成です。)
## 6.3.7 デプロイメントの削除
クリーンナップには次のコマンドを実行します。  
デプロイメント、レプリカセット、ポッドといったオブジェクトを一括削除します。
```
kube-master:~/# kubectl delete deployment webserver
```
## 6.4 ジョブによるポッドの実行
## 6.4.1 kubectlによるジョブ制御化でのポッドの実行
```
kube-master:~/# kubectl create job hello-world --image=hello-world
```
```
job.batch/hello-world created
```
```
kube-master:~/# kubectl get all
```
```
NAME                    READY   STATUS              RESTARTS   AGE
pod/hello-world-c8d87   0/1     ContainerCreating   0          6s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   13d

NAME                    COMPLETIONS   DURATION   AGE
job.batch/hello-world   0/1           6s         7s
```
## 6.4.2 ポッドの終了コードによるコントローラの振る舞い
ジョブはコンテナのプロセスのexit値で、成功か失敗を判定しています。  
次の例で終了コードの違いでどう振る舞いが変わるのか確認します。
```
kube-master:~/# kubectl create job job-1 --image=ubuntu -- /bin/bash -c "exit 0"
```
```
kube-master:~/# kubectl get jobs
```
```
NAME          COMPLETIONS   DURATION   AGE
job-1         0/1           4s         5s
```
```
kube-master:~/# kubectl create job job-2 --image=ubuntu -- /bin/bash -c "exit 1"
```
```
kube-master:~/# kubectl get jobs
```
```
NAME          COMPLETIONS   DURATION   AGE
job-1         1/1           44s        62s
job-2         0/1           36s        36s
```
```
kube-master:~# kubectl get pod
```
```
NAME                READY   STATUS      RESTARTS   AGE
job-1-6ggs2         0/1     Completed   0          2m23s
job-2-6l8kz         0/1     Error       0          34s
job-2-c754f         0/1     Error       0          117s
job-2-wf7pr         0/1     Error       0          65s
```
job-1はジョブが完了していますが、job-2はリトライを繰り返していることがわかります。
