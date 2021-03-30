# サービス
サービスとは、一時的な存在であり永続的なIPアドレスを持たないポッドに対し、クライアントがアクセスするためのオブジェクトです。
|サービスタイプ|説明|
|:---|:---|
|CluserIP|ポッドネットワーク上のポッドから内部DNSに登録された名前でアクセスできる|
|NodePort|ClusterIPのアクセス可能範囲に加えて、k8sクラスタ外のクライアントも、</br>ノードのIPアドレスとポート番号を指定することでアクセスできる|
|LoadBalancer|NodePortのアクセス可能範囲に加えて、k8sクラスタ外のクライアントも、</br>代表IPアドレスとプロトコルのポート番号でアクセスできる|
|ExternalName|k8sクラスタ内のポッドネットワーク上のクライアントから、</br>外部のIPアドレスを名前でアクセスできる。|

## 9.1 サービスタイプClusterIP
サービスのマニフェストでサービスタイプを省略するとClusterIPとして扱われます。  
- 代表IPアドレス
- 負荷分散
- DNS登録

マニフェストに`clusterIP:None`をセットした場合は、ヘッドレスモードでサービスが動作します。  
この設定では、代表IPアドレスを取得せず、負荷分散も行われません。その代わり、ポッド群のIPアドレスを内部DNSに登録し、ポッドのIPアドレス変更にも対応して最新状態を保ちます。

## 9.2 サービスタイプNodePort
ClusterIPに加えて、ノードのIPアドレスに公開用ポート番号を開きます。  
ノードの特定ポートとポッドの特定ポートを紐付けます。(ポートフォワードのような仕組み。)  
クラスタの全ノードに公開用ポートが開設され、ノードで受けたリクエストはすべてのノード上に存在するポッドを対象に負荷分散し転送されます。(設定次第で挙動を変えることも可能です。)
## 9.3 サービスタイプLoadBalancer
ロードバランサーと連携し、ポッドのアプリケーションを外部のネットワークからアクセスできるようになります。  
また、LoadBalancerはNodePortの上に作られるため、ClusterIPも自動的に作られます。
## 9.4 サービスタイプExternalName
飛ばし
## 9.5 サービスとポッドとの関連付け
サービスは転送先のポッドを決定する際にセレクターのラベルに一致するポッドをetcdから選び出し、転送先のポッドのIPアドレスを取得します。  
デプロイメントのマニフェストに対してサービスのマニフェストを作成します。  
このとき、サービスのセレクターとデプロイメントのポッドテンプレートに、同じラベルを記述します。  
ラベルが一致することで、サービスのリクエスト転送先ポッドが決まります。  
  
ラベルによる転送先の決定手法は、サービスのセレクターに設定するラベルを変更するだけで転送先のポッド群を変更できます。  
しかし、ラベルが重複してしまうと、意図しない対応関係ができてしまい、以上動作の原因となります。
## 9.6 サービスのマニフェストの書き方
デプロイメントのマニフェストとサービスのマニフェストを作成します。
```
### FileName: deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
spec:
  replicas: 3
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
```
### FileName: svc.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
    - protocol: TCP
      port: 80
```
## 9.6.1 サービスの作成と機能確認
作成したYAMLファイルを利用して、オブジェクトを作成してみます。
```
kube-master:~/# kubectl apply -f deploy.yaml
kube-master:~/# kubectl apply -f svc.yaml
```
結果を確認します。サービスが実行されていることがわかります。
```
kube-master:~/# kubectl get all
```
```
NAME                              READY   STATUS    RESTARTS   AGE
pod/web-deploy-86cd4d65b9-24wdf   1/1     Running   0          113s
pod/web-deploy-86cd4d65b9-bbmnc   1/1     Running   0          113s
pod/web-deploy-86cd4d65b9-c48l8   1/1     Running   0          113s

NAME                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/kubernetes    ClusterIP   10.96.0.1        <none>        443/TCP   15d
service/web-service   ClusterIP   10.102.165.216   <none>        80/TCP    101s <- これがサービス

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/web-deploy   3/3     3            3           114s

NAME                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/web-deploy-86cd4d65b9   3         3         3       114s
```
## 9.6.2 サービスへのアクセス
wgetを使ってサービスの代表IPに対してアクセスしてみます。
```
kube-master:~/# wget -q -O - http://10.102.165.216
```
```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<以下省略>
```
## 9.6.3 生成されたポッドの環境変数
サービスを生成したあとに起動されたポッドには、サービスにアクセスするための環境変数がセットされています。  
確認してみましょう。
```
kube-master:~/# kubectl get pod -o wide
```
```
NAME                          READY   STATUS    RESTARTS   AGE     IP            NODE          NOMINATED NODE   READINESS GATES
web-deploy-86cd4d65b9-24wdf   1/1     Running   0          3h26m   10.244.2.65   kube-node02   <none>           <none>
web-deploy-86cd4d65b9-bbmnc   1/1     Running   0          3h26m   10.244.1.44   kube-node01   <none>           <none>
web-deploy-86cd4d65b9-c48l8   1/1     Running   0          3h26m   10.244.2.64   kube-node02   <none>           <none>
```
```
kube-master:~/# kubectl exec -it web-deploy-86cd4d65b9-24wdf -- /bin/bash
```
```
web-deploy-86cd4d65b9-24wdf:/# env | grep WEB_SERVICE 
```
```
WEB_SERVICE_SERVICE_PORT=80
WEB_SERVICE_PORT_80_TCP_ADDR=10.102.165.216
WEB_SERVICE_PORT_80_TCP_PROTO=tcp
WEB_SERVICE_SERVICE_HOST=10.102.165.216
WEB_SERVICE_PORT_80_TCP=tcp://10.102.165.216:80
WEB_SERVICE_PORT=tcp://10.102.165.216:80
WEB_SERVICE_PORT_80_TCP_PORT=80
```
次に今回起動した各ポッドが応答していることを確かめます。  
3つのポッドのNginxサーバのindex.htmlファイルに、各ポッドのホスト名を書き込みます。
```
kube-master:~/# for pod in $(kubectl get pods | awk 'NR>1 {print $1}' | grep web-deploy); do kubectl exec $pod -- /bin/sh -c "hostname > /usr/share/nginx/html/index.html"; done
```
別のターミナルでサービスにアクセスします。
```
kube-master:~/# wget -q -O - http://10.102.165.216
```
何度もサービスにアクセスしてみると3つのサーバに分散されていることがわかります。
## 9.8 セッションアフィニティ
アプリケーションによっては、代表IPアドレスで受けたリクエストを常に同じポッドに転送したい場合があります。  
そのような場合は、マニフェストにキー項目としてセッションアフィニティを追加して値にClientIPをセットすることで、クライアントのIPアドレスで転送先を固定することができます。
```
### FileName: svc-sa.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: web
  ports:
    - protocol: TCP
      port: 80
  sessionAffinity: ClientIP   # クライアントIPアドレスで転送先ポッドを決定する
```
実際に作成したマニフェストを適用してみます。
```
kube-master:~/# kubectl apply -f svc-sa.yaml
```
サービスのリストを表示して代表IPアドレスを確認します。
```
kube-master:~/# kubectl get service
```
```
NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
web-service   ClusterIP   10.102.165.216   <none>        80/TCP    3h51m
```
何度かサービスの代表IPアドレスに対して実行し応答がすべて同じホスト名であることを確認します。
```
kube-master:~/# wget -q -O - http://10.102.165.216
```
## 9.9 NortPortの利用
NodePortタイプのサービスを生成するYAMLは次のようになります。
