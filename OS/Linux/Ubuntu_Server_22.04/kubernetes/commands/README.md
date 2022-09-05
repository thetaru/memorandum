# コマンドリファレンス
## APIグループ
```sh
kubectl api-resources
```

## APIグループのバージョン
```sh
kubectl api-versions
```

## ロールアウト
### Deployment
```sh
kubectl rollout restart deployment/<deployment-name>
```
### StatefulSet
```sh
kubectl rollout restart statefulset/<statefulset-name>
```
### DaemonSet
```sh
$ kubectl rollout restart daemonset/<daemonset-name>
```
