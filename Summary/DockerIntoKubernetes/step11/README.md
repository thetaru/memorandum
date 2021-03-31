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
PV作成のマニフェスト
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
```
### FileName: pvc.yaml
apiVersion: v1                  # 永続ボリューム要求API
kind: PersistentVolumeClaim
metadata:                       # ObjectMeta v1 meta
    name: data1
spec:                           # 永続ボリューム要求の仕様
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
      requests:
          storage: 1Gi
```
PVを作成します。
```
kube-master:~/# kubectl apply -f pv.yaml
```
作成したマニフェストからPVCを適用します。
```
kube-master:~/# kubectl apply -f pvc.yaml
```
```
kube-master:~/# kubectl get pvc,pv
```
