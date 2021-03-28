# マニフェストとポッド
## 7.1 マニフェストの書き方
## 7.1.1 Nginxコンテナを実行するマニフェスト
```
### FileName: nginx-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
```
## 7.1.2 マニフェストの適用
```
kube-master:~# kubectl apply -f nginx-pod.yaml
```
