# コマンドリファレンス
## APIグループ
```sh
kubectl api-resources
```
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
kubectl rollout restart daemonset/<daemonset-name>
```

## ログ
```sh
# tail -n
kubectl logs --tail=30 <pod-name>
```
```sh
# tail -f
kubectl logs -f <pod-name>
```
