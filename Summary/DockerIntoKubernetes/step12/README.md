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
      accessModes: [ "ReadWriteOnce" ]
      ## 環境に合わせて選択して、storageの値を編集
      #storageClassName: ibmc-file-bronze   # 容量 20Gi IKS
      #storageClassName: gluster-heketi     # 容量 12Gi GlusterFS
      storageClassName: standard            # 容量 2Gi  Minikube/GKE
      resources:
        requests:
          storage: 2Gi
```
