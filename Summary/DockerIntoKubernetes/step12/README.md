# ステートフルセット
ステートフルセットとは、コントローラの一種であり、永続ボリュームとポッドとの組み合わせを制御するにに適しています。  
このコントローラは、ポッドと永続ボリュームの対応関係をより厳格に管理し、永続ボリュームのデータ保護を優先するように振る舞います。
## 12.1 デプロイメントとの違い
ステートフルセットの特徴をデプロイメントと対比しながら挙げています。
### (1) ポッド名と永続ボリューム名
ステートフルセット管理下のポッド名は、ステートフルセット名の末尾に連番を付与して命名されます。  
ステートフルセットでは、ポッドと永続ボリュームのセットを単位として、レプリカに指定した数が生成されます。
### (2) サービスとの連携と名前解決
ステートフルセット管理下のポッドへリクエストを転送するためのサービスには、代表IPアドレスを持たないClusterIPのヘッドレスモードを利用しなければなりません。  
クライアントがサービス名でIPアドレスを解決すると、ステートフルセット管理下にあるポッドのIPアドレスをランダムに返します。  
  
ステートフルセットのマニフェストの`spec.serviceName:`に連携するサービス名を設定すると、末尾に連番が付与されたポッド名で個々のポッドのIPアドレスを解決できるようになります。
### (3) ポッド喪失時の振る舞い
ステートフルセット管理下のポッドが失われた場合は、同じポッド名を維持してポッドを起動します。  
対応した永続ボリュームは存続を続け、末尾番号が同じ名前のポッドが再びマウントされます。ただしIPは変わります。  
そのため、ステートフルセット制御化にあってもポッドへのアクセスには内部DNSの名前解決を使用します。
### (4) ノード停止時の振る舞い
ステートフルセットは、データが破壊されないように振る舞うことを第一に設計されています。  
次のいずれか1つのアクションがあった場合にのみ、ステートフルセットは失われたポッドを代替ノード上で起動します。
- 障害ノードをk8sクラスタのメンバーから削除する
- ノード上の問題があるポッドを強制終了する
- 障害停止したノードを再起動する

### (5) ポッドの順番制御
ステートフルセットのポッド名の連番は、デフォルト設定の状態ではポッドの起動と停止のほか、ローリングアップデートの順番にも利用されます。  
PV(`storageClassName: standard`)がすでにあることが前提です。
## 12.2 マニフェストの書き方
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql        ## この名前がk8s内のDNS名として登録されます。
  labels:
    app: mysql-sts
spec:
  ports:
  - port: 3306
    name: mysql
  clusterIP: None    ## 特徴① ヘッドレスサービスを設定
  selector:
    app: mysql-sts   ## 後続のステートフルセットと関連づけるラベル
---
## MySQL ステートフルセット
#
apiVersion: apps/v1         ## 表1 ステートフルセット参照
kind: StatefulSet
metadata:
  name: mysql
spec:                       ## 表2 ステートフルセットの仕様
  serviceName: mysql        ## 特徴② 連携するサービス名を設定
  replicas: 1               ## ポッド起動数
  selector:
    matchLabels:
      app: mysql-sts
  template:                 ## 表3 ポッドテンプレートの仕様
    metadata:
      labels:
        app: mysql-sts
    spec:
      containers:           
      - name: mysql
        image: mysql:5.7    ## Docker Hub MySQLリポジトリを指定
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: qwerty
        ports:
        - containerPort: 3306
          name: mysql
        volumeMounts:       ## 特徴③コンテナ上のマウントポイント設定
        - name: pvc
          mountPath: /var/lib/mysql
          subPath: data     ## 初期化時に空ディレクトリが必要なため
        livenessProbe:      ## MySQL稼働チェック
          exec:
            command: ["mysqladmin","-p$MYSQL_ROOT_PASSWORD","ping"]
          initialDelaySeconds: 60
          timeoutSeconds: 10
  volumeClaimTemplates:     ## 特徴④ボリューム要求テンプレート
  - metadata:
      name: pvc
    spec:                   ## 表4 永続ボリューム要求の雛形
      accessModes:
        - ReadWriteOnce
      volumeMode: Filesystem
      storageClassName: standard            # 容量 2Gi  Minikube/GKE
      resources:
        requests:
          storage: 1Gi
```
マニフェストを適用します。
```
kube-master:~/# kubectl apply -f mysql-sts.yaml 
```
デプロイ後、永続ボリュームも一緒に生成されます。
```
kube-master:~/# kubectl get svc,sts,po
```
```
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
service/mysql        ClusterIP   None         <none>        3306/TCP   3m18s

NAME                     READY   AGE
statefulset.apps/mysql   1/1     3m17s

NAME                             READY   STATUS    RESTARTS   AGE
pod/mysql-0                      1/1     Running   0          3m16s
```
PVもみておきます。
```
kube-master:~/# kubectl get pv
```
```
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                 STORAGECLASS   REASON   AGE
pv1     1Gi        RWO            Delete           Bound    default/pvc-mysql-0   standard                53m
```
次に永続ボリュームが引き継がれることを確認するために、MySQLにログインして`create database`で適当なデータベースを作成します。
```
kube-master:~/# kubectl exec -it mysql-0 -- bash
# mysql -u root -u p qwerty
> create database hello;
> show databases;
```
永続ボリュームに書き込んだらステートフルセットを削除し、永続ボリュームが存続していることを確認します。  
ポッドやステートフル接テオは削除されても、PVCとPVは存続しています。
```
kube-master:~/# kubectl delete -f mysql-sts.yaml
kube-master:~/# kubectl get svc,sts,po
kube-master:~/# kubectl get pvc,pv
```
再びステートフルセットを作成して、ポッドと永続ボリュームの関係を復元できることと、データが保持されていることを確認します。
```
kube-master:~/# kubectl apply -f mysql-sts.yaml
kube-master:~/# kubectl exec -it mysql-0 -- bash
# mysql -u root -u p qwerty
> show databases;
```
ステートフルセット削除前に作成したデータはステートフルセットの削除後も存続し、再びステートフルセットを作成してデータにアクセスできることがわかりました。
## 12.3 手動テイクオーバーの方法
ハードウェア保守でノードを一時的に停止したい場合の操作を説明します。  
手順は以下の通り
1. ノード2(保守対象)の新たなポッドのスケジュールを停止し、ポッドを移動する。
2. ノード1(ノード2以外のノードならなんでも)で移動したノードが起動することを確認

node02で動作していることを確認します。
```
kube-master:~/# kubectl get pod
```
```
NAME                         READY   STATUS    RESTARTS   AGE   IP             NODE          NOMINATED NODE   READINESS GATES
mysql-0                      1/1     Running   0          86s   10.244.2.114   kube-node02   <none>           <none>
```
node02への新たなスケジュールを禁止
```
kube-master:~/# kubectl cordon kube-node02
```
```
node/kube-node02 cordoned
```
稼働中のポッドをnode02からnode01へ移行します。
```
kube-master:~/# kubectl drain kube-node02 --ignore-daemonsets
```
```
node/kube-node02 already cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/kube-flannel-ds-49lg5, kube-system/kube-proxy-h8nrh
evicting pod default/mysql-0
pod/mysql-0 evicted
node/kube-node02 evicted
```
以降完了後の状態確認
```
kube-master:~/# kubectl get pod mysql-0 -o wide
```
```
NAME      READY   STATUS    RESTARTS   AGE     IP            NODE          NOMINATED NODE   READINESS GATES
mysql-0   1/1     Running   0          3m12s   10.244.1.61   kube-node01   <none>           <none>
```
移行後はnode02のスケジュールを再開させます。  
ポッドの移行はライブマイグレーションでないので一旦終了してから別ノードで起動されることに注意してください。  
なので一度完全にアクセスのない状態にしてから実施しましょう。(ふつうのことですけどね...)
```
kube-master:~/# kubectl uncordon kube-node02
```
## 12.4 ノード障害時の動作
## 12.5 テイクオーバー自動化コードの開発
ノードの障害停止に巻き込まれたポッドを他のノードへ対比させてサービスを再開する。  
この機能の実装のポイントを挙げます。(前提としてkubectlコマンドは利用しません。)
1. k8sAPIライブラリを利用したコード開発: ポッド上のコンテナのプログラムからk8sAPIを直接コールすることで、k8sクラスタの状態変化に対応するアクションを自動化します。
2. k8sクラスタ操作の特権をポッドへ付与: ポッド上のコンテナがk8sクラスタを操作するためのアクセス権をコンテナに与えます。
3. 名前空間の分離: 名前空間を分けて、ポッドの管理の範囲も分けます。
4. k8sクラスタ構成変更の自動対応: この自動化ポッドは、ノードの停止・追加・変更に対応できる必要があります。(デーモンセットコントローラでポッドを起動する。)

### (1) k8sAPIをアクセスするプログラムの開発
### ■ コンテナビルド
まずコンテナイメージを作成します。  
修正したDockerfileは以下です。
```
FROM ubuntu:16.04
RUN apt-get update # && apt-get install -y curl apt-transport-https

# pyhon
RUN apt-get install -y python3 python3-pip
RUN pip3 install kubernetes

COPY main.py /main.py

WORKDIR /
CMD python /main.py
```
Dockerfileを元にイメージのビルドをします。
```
kube-master:~/# docker build --tag alallilianan/liberator:0.1 .
```
生成したイメージをリポジトリに登録します。
```
kube-master:~/# docker images
kube-master:~/# docker login
kube-master:~/# docker push alallilianan/liberator:0.1
```
### ■ pythonプログラム
次のpythonのプログラムからk8sクラスタを操作します。
```py
### FileName: main.py
# coding: UTF-8
#
# 状態不明ノードをクラスタから削除する
#
import signal, os, sys
from kubernetes import client, config
from kubernetes.client.rest import ApiException
from time import sleep

uk_node = {}  # KEYは状態不明になったノード名、値は不明状態カウント数

## 停止要求シグナル処理
def handler(signum, frame):
    sys.exit(0)

## ノード削除 関数
def node_delete(v1,name):
    body = client.V1DeleteOptions()
    try:
        resp = v1.delete_node(name, body)
        print("delete node %s done" % name)
    except ApiException as e:
        print("Exception when calling CoreV1Api->delete_node: %s\n" % e)

## ノード監視 関数
def node_monitor(v1):
    try:
        ret = v1.list_node(watch=False)
        for i in ret.items:
            n_name = i.metadata.name
            #print("%s" % (i.metadata.name)) #デバック用
            for j in i.status.conditions:
                #print("\t%s\t%s" % (j.type, j.status)) #デバック用
                if (j.type == "Ready" and j.status != "True"):
                    if n_name in uk_node:
                        uk_node[n_name] += 1
                    else:
                        uk_node[n_name] = 0
                    print("unknown %s  count=%d" % (n_name,uk_node[n_name]))
                    # カウンタが3回超えるとノードを削除
                    if uk_node[n_name] > 3:
                        del uk_node[n_name]
                        node_delete(v1,i.metadata.name)
                # 1回でも状態が戻るとカウンタリセット
                if (j.type == "Ready" and j.status == "True"):
                    if n_name in uk_node:
                        del uk_node[n_name]
    except ApiException as e:
        print("Exception when calling CoreV1Api->list_node: %s\n" % e)

## メイン        
if __name__ == '__main__':
    signal.signal(signal.SIGTERM, handler) # シグナル処理
    config.load_incluster_config()         # 認証情報の取得
    v1 = client.CoreV1Api()                # インスタンス化
    # 監視ループ 
    while True:
        node_monitor(v1)
        sleep(5) # 監視の間隔時間
```
このコードを実行するポッドには、ノードの状態取得と削除というk8sクラスタの構成を変更するためのアクセス権が必要になります。  
なのでサービスアカウントhigh-availabilityを作成して、それらのアクセス権を付与します。  
### (2) RBACのアクセス権付与のマニフェスト作成
RBACは役割基準のアクセス制御のことです。  
役割(ロール)を設定して、その役割に対してアクセスできる権限を設定します。  
次のマニフェストは名前空間に対してアカウントを作成します。
```yaml
### FileName: service-account.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: tkr-system     # 属する名前空間
  name: high-availability   # サービスアカウント名
```
次のマニフェストは上記のサービスアカウントに対して、役割とアクセス権を付与します。
```yaml
### FileName: role-based-access-ctl.yaml
kind: ClusterRole
apiVersion: rbac.authorizatoin.k8s.io/v1
metadata:
  name: nodes
rules:
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["list", "delete"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: nodes
subjects:
  - kind: ServiceAccount      # サービスアカウント名
    name: high-availavility   # 名前空間の指定(必須)
    namespace: tkr-system     # 作成したサービスアカウントと同一名を設定
roleRef:
  kind: ClusterRole
  name: nodes
  apiGroup: rbac.authorization.k8s.io
```
### (3) 名前空間によるスコープ設定のマニフェスト作成
名前空間をスコープ設定のために利用します。  
k8sクラスタに名前空間`tkr-system`を追加し、サービスアカウント、クラスタロール、クラスタロールバインディングを設定します。  
この名前空間には、ノード監視などk8sクラスタの運用のために使われます。
```yaml
### FileName: namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: tkr-system        # 専用の名前空間
```
これを適用して名前空間を分離するができます。
### (4) マニフェストをk8sクラスタへ適用する
```
kube-master:~/# kubectl applf -f service-account.yaml
kube-master:~/# kubectl applf -f role-based-access-ctl.yaml
kube-master:~/# kubectl applf -f namespace.yaml
```
### (5) クラスタ構成変更への自動対応
kubernetesには、すべてのノードでポッドを実行するためのコントローラ`デーモンセット`があります。  
デーモンセットは管理下にポッドを、k8sクラスタの全ノードで稼働するように制御します。  
デーモンセットが削除されると、その管理下のポッドは全ノードから削除されます。さらに、デーモンセットの管理下で配置されたポッドの所属ノードを限定する際はノードセレクタを設定します。  
  
今回、名前空間`tkr-system`にデーモンセットを作成することで、アプリケーションの管理者はデーモンセットとその管理化のポッドの存在を意識することなく、k8sクラスタのノードの追加と削除を実施できるようになります。
次のマニフェストは、ビルドしたイメージをk8sクラスタ全ノード上で動作させるためのマニフェストです。  
そのために、作成したサービスアカウントのアクセス権を作成した名前空間に設定します。
```yamme
### FileName: daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: liberator
  namespace: tkr-system                           # システム用名前空間
spec:
  selector:
    matchLabels:
      name: liberator
  template:
    metadata:
      labels:
        name: liberator
    spec:
      serviceAccountName: high-availability       # 権限と紐づくアカウント
      containers:
        - name: liberator
          image: alallilianan/liberator:0.1
          resources:
            limits:
              memory: 200Mi
            requests:
              cpu: 100m
              memory: 200Mi
```
マニフェストを適用します。
```
kube-master:~/# kubectl apply -f dameonset.yaml 
```
名前空間の指定なしでデーモンセットをリストしたケース
```
kube-master:~/# kubectl get daemonset
```
```
No resources found in default namespace.
```
名前空間 tkr-system を指定してデーモンセットをリストしたケース
```
kube-master:~/# kubectl get daemonset -n tkr-system
```
```
NAME        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
liberator   2         2         0       2            0           <none>          2m42s
```
```
kube-master:~/# kubectl get pod -n tkr-system
```
```NAME              READY   STATUS    RESTARTS   AGE
liberator-gqtfd   1/1     Running   0          33s
liberator-xc6ll   1/1     Running   0          2m7s
```
デーモンセットの状態を確認します。
```
kube-master:~/# kubectl get daemonset -n tkr-system
```
```
NAME        DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
liberator   2         2         2       2            2           <none>          3m23s
```
## 12.6 障害回復テスト
障害回復テストを行います。  
ステートフルセットの管理下で、ポッドが稼働するノードをシャットダウンし、残ったノードでサーバがサービス再開するまでの様子を確認します。  
