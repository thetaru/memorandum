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
RUN pip3 install --upgrade pip
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
RBACは役割基準のアクセス制御のことです。役割(ロール)を設定して、その役割に対してアクセスできる権限を設定するアクセスコントロールです。
