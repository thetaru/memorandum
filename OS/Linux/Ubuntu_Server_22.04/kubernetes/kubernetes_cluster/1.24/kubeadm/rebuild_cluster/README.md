# クラスタの再構築
## [ワーカー作業] ワーカーノードの初期化
ワーカーノード上のPodを削除する。
```sh
kubectl drain <node-name> --delete-local-data --force --ignore-daemonsets
```
`kubeadm`により初期化
```sh
kubeadm reset
```

## [マスター作業] マスターノードの初期化
ワーカーノードの一覧を取得する。
```sh
kubectl get node
```
ワーカーノードを削除する。
```sh
# ワーカーノードの台数分、下記コマンドを実行する
kubectl delete node <node-name>
```
ワーカーノードが削除されたことを確認する。
```
kubectl get node
```
`kubeadm`により初期化
```sh
kubeadm reset
```
