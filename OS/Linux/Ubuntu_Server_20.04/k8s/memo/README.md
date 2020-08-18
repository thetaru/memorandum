# メモ
## ポッドの実行
```
$ kubectl run <object-name> --image=<image-name> -it --restart=<option>
```
## ポッドの表示
```
$ kubectl get node
```
## ポッドの削除
```
$ kubectl delete pod <object-name>
```
## デプロイメントの実行(Always)
podをデプロイメントコントローラー下で実行すること。
```
$ kubectl create deployment --image=<image-name> <object-name>
```
```
$ kubectl get deploy,po
```
```
$ kubectl delete deployment <object-name>
```
```
### 複数台のポッドを起動
$ kubectl create deployment --image=<image-name> <object-name>
$ kubectl scale --replicas=<number of pod> deployment/<object-name>
```
```
### 複数台でも削除の仕方は同じ
$ kubectl delete deployment <object-name>
```
## ジョブによるポッドの実行(OnFailure)
```
$ kubectl create job <object-name> --image=<image-name>
```
