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
## 7.2 マニフェストの適用
YAMLのマニフェストファイルをk8sクラスタへ送り込んてオブジェクトを生成するコマンドです。  
これはポッドだけでなく、すべてのk8sオブジェクトに共通する適用方法です。  
もし同一名のオブジェクトが存在する場合は、オブジェクトのスペックを変更するように働きます。
```
kube-master:~# kubectl apply -f <マニフェスト名>
```
作成したk8sオブジェクトを削除するコマンドです。  
`-f`に続くファイル名には、URLを指定することもできるのでGitHub上のYAMLファイルを適用することもできます。
```
kube-master:~# kubectl delete -f <マニフェスト名>
```
## 7.3 ポッドの動作検証
```
kube-master:~# kubectl apply -f nginx-pod.yaml
```
```
pod/nginx created
```
```
kube-master:~# kubectl get pod
```
```
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          29s
```
