# マスターノードのPodスケジュールを有効にする
マスター/ワーカー構成のkubernetesノードを構築する場合、通常マスターノードにはPodがスケジュールされない設定となっている。  
そのため、マスター/ワーカー構成ではPodスケジュールを有効にする必要がある。

## マスターノードの確認
マスターノードの名前を確認する。
```sh
kubectl get node
```
```
NAME     STATUS   ROLES           AGE   VERSION
master   Ready    control-plane   15m   v1.26.1
```

## マスターノードのTaintの確認
マスターノードには`node-role.kubernetes.io/control-plane:NoSchedule`Taintsが設定されている。
```sh
kubectl describe nodes master | grep -i taint
```
```
Taints: node-role.kubernetes.io/control-plane:NoSchedule
```

## NoSchedule Taintsの解除方法
ノード側で対応する方法とPod側で対応する方法がある。
### ■ ノード側で対応する場合
任意のPodがマスターノードでスケジュール可能となる。
```sh
kubectl taint nodes master node-role.kubernetes.io/control-plane:NoSchedule-
```
```
node/master untainted
```

### ■ Pod側で対応する場合
マニフェストに以下を組み込むことで、特定のPodがマスターノードでスケジュール可能となる。
```yaml
tolerations:
- key: node-role.kubernetes.io/control-plane
  effect: NoSchedule
```

## シングルノード構成の場合の注意点
Deploymentでは、レプリカ数が2以上の場合、Podを複数ノードに分散配置する。  
そのため、シングルノード構成ではエラーとなってしまうが、`Node Affinity`を利用しノードを指定することで回避できる。  
  
ノードにラベルを設定する。
```sh
kubectl label node <node name> nodeName=<label name>
```
