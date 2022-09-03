# Rook-Cephクラスタの削除手順
## ■ bluestore
bluestoreを利用する場合、OSDのデータ保存には特定のデバイスを利用する。  
そのため、dataDirHostPathの削除と利用したデバイスの初期化が必要になる。  
以下のyaml(抜粋)には、dataDirHostPathは`/var/lib/rook`、デバイスは`/dev/sdb`が指定されている。
```yaml
apiVersion: ceph.rook.io/v1
kind: CephCluster
metadata:
  name: rook-ceph
  namespace: rook-ceph
spec:
  dataDirHostPath: /var/lib/rook
  storage: # cluster level storage configuration and selection
    useAllNodes: true
    useAllDevices: false
    devices:
      - name: "sdb"
```

### dataDirHostPathの削除
ワーカーノード上で実行する。
```
rm -rf /var/lib/rook
```

### デバイスの初期化
GPT/MBRを持つデバイスをディスクパーティションを持たない初期状態にする。  
ワーカーノード上で実行する。
```
sgdisk -Z /dev/sdb
```

## ■ Ref
### Warning: Detected changes to resource XXX which is currently being deleted.
- [Restoring CRDs After Deletion](https://github.com/rook/rook/blob/master/Documentation/Troubleshooting/disaster-recovery.md#restoring-crds-after-deletion)
