# デプロイメント
デプロイメントは、(大雑把に言うと)ポッドの稼働数を管理します。  
デプロイメントは単独で動作するのではなく、レプリカセットと連携してポッド数の制御を行います。
## 8.1 デプロイメントの生成と削除
デプロイメントの生成と削除の手順はポッドと同じです。 
## 8.1.1 マニフェストの例
デプロイメントを生成するマニフェストは以下の通りです。
```yaml
### FileName: deployment1.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy      # デプロイメント名
spec:
  replicas: 3           # ポッドテンプレートからポッドを起動する数
  selector:
    matchLabels:        # コントローラとポッドを対応付けるラベルを指定
      app: web          # ポッドは、このラベルと一致する必要あり
  template:             # template以下がポッドテンプレートで、雛形となる仕様を記述
    metadata:
      labels:
        app: web        # ポッドのラベル、コントローラのmatchLabelsと一致させる必要あり
    spec:
      containers:       # コンテナの仕様
        - name: nginx
          image: nginx:latest
```
## 8.1.2 デプロイメントの生成
デプロイメントのマニフェストを適用
```
### マニフェストの適用
kube-master:~/# kubectl apply -f deployment1.yaml
```
デプロイメントの状態確認
```
kube-master:~/# kubectl get deploy
```
```
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
web-deploy   3/3     3            3           54s
```
レプリカセットの状態確認
```
kube-master:~/# kubectl get replicasets
```
```
NAME                    DESIRED   CURRENT   READY   AGE
web-deploy-86cd4d65b9   3         3         3       2m11s
```
ポッドの状態確認
```
kube-master:~/# kubectl get pod
```
```
NAME                          READY   STATUS    RESTARTS   AGE    IP            NODE          NOMINATED NODE   READINESS GATES
web-deploy-86cd4d65b9-cg7nw   1/1     Running   0          4m2s   10.244.2.33   kube-node02   <none>           <none>
web-deploy-86cd4d65b9-rc9wj   1/1     Running   0          4m2s   10.244.2.32   kube-node02   <none>           <none>
web-deploy-86cd4d65b9-w8nzn   1/1     Running   0          4m2s   10.244.1.19   kube-node01   <none>           <none>
```
## 8.2 スケール機能
replicasの値を変更して、ポッド数を増減することで、処理能力を調整する機能です。  
ここでは、静的にreplicasの値を変更する方法を扱います。  
反対に、動的にreplicasの値を調整するオートスケールと呼ばれる機能があります。
## 8.2.1 レプリカ数の変更
実行中のデプロイメントのレプリカ数を変更して処理能力を上げます。  
そのために8.1.1で作成したdeployment1.yamlを編集して、レプリカ数を3から10へ増やします。
```yaml
### FileName: deployment2.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
spec:
  replicas: 10          # 3から10へ変更
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:latest
```
マニフェストを適用します
```
kube-master:~/# kubectl apply -f deployment2.yaml
```
```
deployment.apps/web-deploy configured
```
ポッド数が10へ増えていることを確認します。
```
kube-master:~/# kubectl get pod
```
```
NAME                          READY   STATUS              RESTARTS   AGE
web-deploy-86cd4d65b9-96bht   0/1     ContainerCreating   0          30s
web-deploy-86cd4d65b9-9jc5b   0/1     ContainerCreating   0          31s
web-deploy-86cd4d65b9-cg7nw   1/1     Running             0          13m
web-deploy-86cd4d65b9-lzbrr   0/1     ContainerCreating   0          31s
web-deploy-86cd4d65b9-mfvjd   0/1     ContainerCreating   0          31s
web-deploy-86cd4d65b9-mj9kr   0/1     ContainerCreating   0          31s
web-deploy-86cd4d65b9-ql8x6   0/1     ContainerCreating   0          30s
web-deploy-86cd4d65b9-r7b8m   0/1     ContainerCreating   0          31s
web-deploy-86cd4d65b9-rc9wj   1/1     Running             0          13m
web-deploy-86cd4d65b9-w8nzn   1/1     Running             0          13m
```
同様の処理を`kubectl scale`を利用して実行できます。
```
kube-master:~/# kubectl scale --replicas=10 deployment web-deploy
```
## 8.3 ロールアウト機能
アプリケーションコンテナの更新を意味します。  
ロールアウトを実行するには、事前に新しいイメージをビルドして、リポジトリへ追加登録しておかなければなりません。  
新イメージのリポジトリ名とタグをマニフェストのimageの値にセットして、`kubectl apply -f`で再適用することでロールアウトが開始されます。
## 8.3.1 ロールアウトの実行
```
kube-master:~/# kubectl describe deployment web-deploy
```
```
Name:                   web-deploy
Namespace:              default
CreationTimestamp:      Sun, 28 Mar 2021 14:23:35 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=web
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
<以下省略>
```
`RollingUpdateStrategy`が重要で停止ポッドの許容台数とポッドの稼働数超過(新旧ポッド)の許容台数がわかります。  
編集したマニフェストを適用してロールアウトを実施します。
```
### ロールアウトの実施
kube-master:~/# kubectl apply -f deployment3.yaml
```
```
deployment.apps/web-deploy configured
```
ロールアウト中の様子を確認します。  
`RollingUpdateStarategy`に沿って入れ替わっていくのがわかります。
```
kube-master:~/# kubectl get pod
```
```
NAME                          READY   STATUS              RESTARTS   AGE
web-deploy-7675fc7857-25zdh   1/1     Running             0          48s
web-deploy-7675fc7857-2l7gw   0/1     ContainerCreating   0          54s
web-deploy-7675fc7857-7ldgt   0/1     ContainerCreating   0          2m38s
web-deploy-7675fc7857-927p5   1/1     Running             0          2m48s
web-deploy-7675fc7857-g5vsv   1/1     Running             0          2m49s
web-deploy-7675fc7857-q295s   0/1     ContainerCreating   0          2m48s
web-deploy-7675fc7857-xb96f   0/1     ContainerCreating   0          2m39s
web-deploy-86cd4d65b9-mbq49   1/1     Running             0          2m49s
web-deploy-86cd4d65b9-mfvjd   1/1     Running             0          33m
web-deploy-86cd4d65b9-mm9g9   1/1     Terminating         0          2m49s
web-deploy-86cd4d65b9-pzmk2   1/1     Running             0          2m50s
web-deploy-86cd4d65b9-ql8x6   1/1     Running             0          33m
web-deploy-86cd4d65b9-w8nzn   1/1     Running             0          46m
```
最終的に古いポッドは削除されます。
## 8.4 ロールバック機能
k8sでのロールバックは、ロールアウト前の古いコンテナへ戻すためにポッドを入れ替えることを指します。  
ロールバックでも、ロールアウト同様にクライアントからのリクエストを処理しながら、ポッドを入れ替えます。  
データリカバリは別に考慮する必要があります。
## 8.4.1 ロールバックの実施
ロールバックを実行します。
```
kube-master:~/# kubectl rollout undo deployment web-deploy
```
```
deployment.apps/web-deploy rolled back
```
ロールバック中の様子を確認します。 
```
kube-master:~/# kubectl get pod
```
```
NAME                          READY   STATUS              RESTARTS   AGE
web-deploy-7675fc7857-25zdh   1/1     Terminating         0          23m
web-deploy-7675fc7857-2l7gw   1/1     Terminating         0          23m
web-deploy-7675fc7857-7ldgt   1/1     Terminating         0          25m
web-deploy-7675fc7857-927p5   1/1     Running             0          25m
web-deploy-7675fc7857-g5vsv   1/1     Running             0          25m
web-deploy-7675fc7857-q295s   1/1     Running             0          25m
web-deploy-7675fc7857-xb96f   1/1     Running             0          25m
web-deploy-7675fc7857-xpwff   1/1     Terminating         0          23m
web-deploy-86cd4d65b9-8rsvg   1/1     Running             0          95s
web-deploy-86cd4d65b9-ch588   1/1     Running             0          102s
web-deploy-86cd4d65b9-f289f   1/1     Running             0          102s
web-deploy-86cd4d65b9-gssnc   0/1     ContainerCreating   0          25s
web-deploy-86cd4d65b9-hsknp   0/1     ContainerCreating   0          7s
web-deploy-86cd4d65b9-l6c7g   0/1     ContainerCreating   0          96s
web-deploy-86cd4d65b9-shp4w   0/1     ContainerCreating   0          34s
web-deploy-86cd4d65b9-xfsrn   1/1     Running             0          102s
web-deploy-86cd4d65b9-z48mv   0/1     ContainerCreating   0          13s
```
## 8.5 IPアドレスが変わる/変わらない
ポッドのIPアドレスは、イベントによって変わる場合と変わらない場合があります。  
デプロイメント管理化のポッドを１つ削除して、自動回復した際にできたポッドには新しいIPアドレスが割り当てられています。
## 8.6 自己回復機能
