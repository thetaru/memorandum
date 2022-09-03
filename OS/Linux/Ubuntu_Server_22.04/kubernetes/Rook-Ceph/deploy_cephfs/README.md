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
