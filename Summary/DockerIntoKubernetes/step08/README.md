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
