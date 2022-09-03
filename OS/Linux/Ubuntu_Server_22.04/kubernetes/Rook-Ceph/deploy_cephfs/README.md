# CephFSのデプロイ
## ■ Deploy CephFS
```sh
git clone --single-branch --branch master https://github.com/rook/rook.git
cd rook/deploy/examples
kubectl apply -f filesystem.yaml
```

## ■ Register CephFS StorageClass
```sh
git clone --single-branch --branch master https://github.com/rook/rook.git
cd rook/deploy/examples/csi/cephfs/storageclass.yaml
kubectl apply -f storageclass.yaml
```

## ■ Create CephFS PV
登録したStorageClassを指定してPVCを作ると、CephFSのPVが自動で作られることを確認する。  
以下のyamlファイルを`test_pvc.yaml`とする。
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cephfs-pvc
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: rook-cephfs
```
`test_pvc.yaml`をapplyしてPV、PVCを確認する。
```
kubectl apply -f test_pvc.yaml
kubectl get pv,pvc
```
```
NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                STORAGECLASS   REASON   AGE
persistentvolume/pvc-597b6529-cbe3-4fe1-a2e9-54dad674b289   1Gi        RWX            Delete           Bound    default/cephfs-pvc   rook-cephfs             17m

NAME                               STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
persistentvolumeclaim/cephfs-pvc   Bound    pvc-597b6529-cbe3-4fe1-a2e9-54dad674b289   1Gi        RWX            rook-cephfs    17m

```
