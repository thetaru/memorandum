# Rook-Cephのデプロイ
[公式の手順](https://rook.io/docs/rook/latest/Getting-Started/quickstart/)に従ってデプロイする。
## ■ 環境情報
### OS
```sh
uname -a
```
```
Linux k8s0X 5.15.0-46-generic #49-Ubuntu SMP Thu Aug 4 18:03:25 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
```

### デバイス
```sh
lsblk -i | grep -e disk -e part
```
```
sda      8:0    0  100G  0 disk 
|-sda1   8:1    0    1M  0 part 
|-sda2   8:2    0    1G  0 part /boot
|-sda3   8:3    0    4G  0 part 
`-sda4   8:4    0   95G  0 part /
sdb      8:16   0  200G  0 disk 
```
`/dev/sdb`はOSD用に使用するため、ファイルシステムを入れていない。

### kubernetes
```sh
kubectl version --short
```
```
Client Version: v1.24.3
Kustomize Version: v4.5.4
Server Version: v1.24.3
```

## ■ デバイス名の固定
`/dev/sdb`をOSDとして使いたいので、パーティション領域のデバイス名を固定する。

## ■ Deploy the Rook Operator
```
git clone --single-branch --branch master https://github.com/rook/rook.git
cd rook/deploy/examples
kubectl apply -f crds.yaml -f common.yaml -f operator.yaml
```

## ■ Create a Ceph Cluster
以下に`rook/deploy/examples/cluster.yaml`を変更したyamlファイルを記載する。  
`spec-storage-useAllDevices`と`spec-storage-devices`を変更し、使用するデバイス(今回は`/dev/sdb`)を指定している。
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
上記のyamlファイルを`cluster.yaml`と名前をつけて保存しデプロイする。
```sh
kubectl apply -f cluster.yaml
```
