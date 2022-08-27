# クリーンアップ
## ■ bluestore
bluestoreを利用する場合、OSDのデータ保存には特定のデバイスを利用する。  
そのため、dataDirHostPathの削除と利用したデバイスの初期化が必要になる。  
以下のyamlファイルでは、dataDirHostPathは`/var/lib/rook`、デバイスは`/dev/sdb`が指定されている。
```yaml
apiVersion: ceph.rook.io/v1
kind: CephCluster
metadata:
  name: rook-ceph
  namespace: rook-ceph # namespace:cluster
spec:
  cephVersion:
    image: quay.io/ceph/ceph:v16.2.9
    allowUnsupported: false
  dataDirHostPath: /var/lib/rook
  skipUpgradeChecks: false
  continueUpgradeAfterChecksEvenIfNotHealthy: false
  waitTimeoutForHealthyOSDInMinutes: 10
  mon:
    count: 3
    allowMultiplePerNode: false
  mgr:
    count: 1
    modules:
      - name: pg_autoscaler
        enabled: true
  dashboard:
    enabled: true
    ssl: true
  monitoring:
    enabled: false
    rulesNamespace: rook-ceph
  network:
  crashCollector:
    disable: false
  cleanupPolicy:
    confirmation: ""
    sanitizeDisks:
      method: quick
      dataSource: zero
      iteration: 1
    allowUninstallWithVolumes: false
  annotations:
  labels:
  resources:
  removeOSDsIfOutAndSafeToRemove: false
  storage: # cluster level storage configuration and selection
    useAllNodes: true
    useAllDevices: false
    devices:
      - name: "sdb"
    config:
      databaseSizeMB: "1024"
      journalSizeMB: "1024"
      osdsPerDevice: "1"
    onlyApplyOSDPlacement: false
  disruptionManagement:
    managePodBudgets: true
    osdMaintenanceTimeout: 30
    pgHealthCheckTimeout: 0
    manageMachineDisruptionBudgets: false
    machineDisruptionBudgetNamespace: openshift-machine-api
  healthCheck:
    daemonHealth:
      mon:
        disabled: false
        interval: 45s
      osd:
        disabled: false
        interval: 60s
      status:
        disabled: false
        interval: 60s
    livenessProbe:
      mon:
        disabled: false
      mgr:
        disabled: false
      osd:
        disabled: false
    startupProbe:
      mon:
        disabled: false
      mgr:
        disabled: false
      osd:
        disabled: false
```

### dataDirHostPathの削除
```
rm -rf /var/lib/rook
```

### デバイスの初期化
GPT/MBRを持つデバイスをディスクパーティションを持たない初期状態にする。
```
sgdisk -Z /dev/sdb
```
