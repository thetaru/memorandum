# クラスタの再構築
## ワーカーノードの初期化
ワーカーノード上のPodを削除する。
```sh
# マスター作業
kubectl drain <node-name> --delete-local-data --force --ignore-daemonsets
```
`kubeadm`により初期化
```sh
# ワーカー作業
kubeadm reset
```

## マスターノードの初期化
ワーカーノードの一覧を取得する。
```sh
# マスター作業
kubectl get node
```
ワーカーノードを削除する。
```sh
# マスター作業
kubectl delete node <node-name>
```
ワーカーノードが削除されたことを確認する。
```
# マスター作業
kubectl get node
```
`kubeadm`により初期化
```sh
# マスター作業
kubeadm reset
```
