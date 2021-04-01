# ストレージ
k8sクラスタ上のアプリケーションに対してデータの保全性を確保するために、外部ストレージシステムと連携した永続ボリュームを利用する必要があります。
## 11.1 ストレージの種類とクラスタ構成
### 内部ボリューム(ノード内部の記憶領域)
ノード内部のボリュームには、emptyDirとhostPathがあります。

- シングルノードクラスタ\[emptyDir,hostPath\]
    - emptyDirは同一ポット内ファイル共有
    - hostPathは同一ノード内ファイル共有
- マルチノードクラスタ\[hostPath\]
    - ノード間でファイル共有は不可
    - ノード停止でデータが喪失

### 外部ボリューム(外部記憶装置)
- マルチノードクラスタ＋ストレージシステム\[PersistentVolume\]
    - 外部ストレージシステムの利用(NFS, GlusterFS,...)

## 11.1.1 emptyDir
emptyDirはノードのディスクをポッドから一時的に利用する仕組みであり、同一ポッドのコンテナ間でボリュームを共有できますが、異なるポッド間での共有はできません。  
そして、ポッドが終了すると、emptyDirは一緒に削除されます。(一時データ置き場としての利用ができます。)
## 11.1.2 hostPath
hostPathはノードのディスクをポッドから一時的に利用する仕組みであり、同一ポッドや異なるポッドでも、同じ永続ボリュームとして共有することができます。  
ポッドが終了してもhostPathが一緒に削除されることはありません。  
しかし、ノード間でファイル共有できません。

## 11.1.3 まとめ
外部ボリュームが最強!!!

## 11.2 ストレージシステムの諸方式
ストレージシステムの方式によって永続ボリュームの機能に差異が生じます。
## 11.3 ストレージの抽象化と自動化
ポッド上のコンテナは、共通の定義によって、永続ボリュームをマウントすることができます。  
具体的には、マニフェストのポッドテンプレートにボリューム情報を記述すれば、アプリケーションは永続ボリュームとして利用開始します。
  
k8sオブジェクトは、永続ボリューム要求(PVC)と永続ボリューム(PV)の2つから成ります。  
あらかじめPVCを作成しておけば、ポッドのマニフェストにPVCの名前を記述することで、永続ボリュームをコンテナにマウントできます。
## 11.4 永続ボリューム利用の実際
PV作成のマニフェストです。自ノードの/data/pv1を作成します。
```yaml
### FileName: pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv1
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: standard
  hostPath:
    path: /data/pv1
    type: DirectoryOrCreate
```
PVC作成のマニフェストを作成します。
```yaml
### FileName: pvc.yaml
apiVersion: v1                  # 永続ボリューム要求API
kind: PersistentVolumeClaim
metadata:                       # ObjectMeta v1 meta
    name: data1
spec:                           # 永続ボリューム要求の仕様
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  storageClassName: standard
  resources:
      requests:
          storage: 1Gi
```
PVを作成します。
```
kube-master:~/# kubectl apply -f pv.yaml
```
PVが作成されていることを確認します。
```
kube-master:~/# kubectl get pv
```
```
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS   REASON   AGE
pv1    1Gi        RWO            Delete           Available           standard                7s
```
作成したマニフェストからPVCを適用します。
```
kube-master:~/# kubectl apply -f pvc.yaml
```
PVCが正常動作していることを確認します。
```
kube-master:~/# kubectl get pvc
```
```
NAME    STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data1   Bound    pv1      1Gi        RWO            standard       3s
```
次は、PVCをマウントするポッドを作成するためのマニフェストです。
```yaml
### FileName: pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod1
spec:
  volumes:
    - name: pvc1
      persistentVolumeClaim:
        claimName: data1       # PVCの名前をセット
  containers:
    - name: ubuntu
      image: ubuntu:16.04
      volumeMounts:
        - name: pvc1
          mountPath: /mnt
      command: ["/usr/bin/tail", "-f", "/dev/null"]
```
マニフェストを適用します。
```
kube-master:~/# kubectl apply -f pod.yaml
```
ポッドが正常起動していることを確認します。
```
kube-master:~/# kubectl get pvc,pv,pod
```
```
NAME                          STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/data1   Bound    pv1      1Gi        RWO            standard       11m

NAME                   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM           STORAGECLASS   REASON   AGE
persistentvolume/pv1   1Gi        RWO            Delete           Bound    default/data1   standard                14m

NAME       READY   STATUS    RESTARTS   AGE
pod/pod1   1/1     Running   0          24s
```
マウントしていることを確認するためにマウントしているノード上の`/data/pv1`にファイルを作成します。
```
kube-node0X:~/# touch /data/pv1/hoge
```
```
kube-master:~/# kubectl exec -it pod1 -- sh
```
hogeファイルがあるか確認します。
```
# ls /data/pv1
```
## 11.5 既存NFSサーバを利用する場合
各ノードはnfs-commonが必要なのでインストールしましょう。
|役割|IPアドレス|
|:---|:---|
|NFS Server|192.168.137.6|
|公開ディレクトリ|/data|

### (1) 永続ボリューム(PV)のマニフェスト作成
```yaml
### FileName: nfs-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-1
  labels:
    name: pv-nfs-1
spec:
  capacity:
    storage: 100Mi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 192.168.137.6    # NFSサーバのIPアドレス
    path: /data              # NFSサーバが公開しているディレクトリ
```
### (2) 永続ボリューム要求(PVC)のマニフェスト作成
```yaml
### FileName: nfs-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-1
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: ""          # ストレージクラスがない永続ボリュームを利用するので、空文字を設定する。
  resources:
    requests:
      storage: "100Mi"
  selector:                     # 対応するPVのラベルを設定する
    matchLabels:
      name: pv-nfs-1
```
### (3) 動作検証
マニフェストを適用してPVとPVCを作成します。
```
kube-master:~/# kubectl apply -f nfs-pv.yaml
kube-master:~/# kubectl apply -f nfs-pvc.yaml
kube-master:~/# kubectl get pv,pvc
```
```
NAME                     CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM           STORAGECLASS   REASON   AGE
persistentvolume/nfs-1   100Mi      RWX            Retain           Bound    default/nfs-1                           34s

NAME                          STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/nfs-1   Bound    nfs-1    100Mi      RWX                           28s
```
永続ボリュームをマウントするポッドを起動して動作を確認します。  
次のマニフェストを適用します。
```yaml
### FileName: nfs-client.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nfs-client
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ubuntu
  template:
    metadata:
      labels:
        app: ubuntu
    spec:
      containers:
        - name: ubuntu
          image: ubuntu:16.04
          volumeMounts:                                    # コンテナにマウントするディレクトリ
            - name: nfs
              mountPath: /mnt
          command: ["/usr/bin/tail", "-f", "/dev/null"]    # コンテナの終了防止のコマンド
      volumes:
        - name: nfs
          persistentVolumeClaim:
            claimName: nfs-1                               # PVC名を設定する
```
マニフェストを適用します。
```
kube-master:~/# kubectl apply -f nfs-client.yaml
kube-master:~/# kubectl get pod
```
```
NAME                         READY   STATUS    RESTARTS   AGE
nfs-client-7ff95d88b-jc8b9   1/1     Running   0          39s
nfs-client-7ff95d88b-mmbgg   1/1     Running   0          39s
```
ポッドの1つにシェルを起動して、読み書きできることを確認します。
```
kube-master:~/# kubectl exec -it nfs-client-7ff95d88b-jc8b9 -- bash
```
```
# df -h
# ls -lR > /mnt/test.log
# md5sum /mnt/test.log
# exit
```
