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
このポッドはバックグランドで起動しており、クラスタネットワーク上で動作しています。  
クラスタネットワークは、k8sクラスタを構築するノード間で通信するための閉じたネットワークです。
```
kube-master:~# kubectl get pod nginx -o wide
```
```
NAME    READY   STATUS    RESTARTS   AGE   IP            NODE          NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          52m   10.244.2.21   kube-node02   <none>           <none>
```
## 7.4 ポッドのヘルスチェック
## 7.4.1 ヘルスチェックの種類
k8sではノードに常駐するkubeletがコンテナのヘルスチェックを担当します。  
kubeletのヘルスチェックでは、次の2種類のプローブを使用して、実行中ポッドのコンテナを検査します。
- 活性プローブ
> コンテナのアプリケーションが実行中であることを探査します。  
> 失敗した場合はポッド上のコンテナを強制終了して再スタートさせます。  
> マニフェストにこのプローブの設定がない場合は、アプリケーションの実行を探査しません。

- 準備状態プローブ
> コンテナからのアプリケーションがリクエストを受けられるか否かを探査します。  
> 失敗した場合はサービスからのリクエストトラフィックを止めます。  
> ポッド起動直後は、このプローブが成功するまでリクエストは転送されません。  
> マニフェストにこのプローブの設定がない場合は、アプリケーションの実行を探査されず、常にリクエストが転送されます。

## 7.4.2 プローブに対応するハンドラ
従来のロードバランサと同じくHTTPでヘルスチェックを行う場合にはポッドに定期アクセスし、対象サーバにはそれに応答するためのサービスを準備します。  
それと同じようにポッドのコンテナは、プローブに対応するハンドラを実装する必要があります。  
このハンドラは、コンテナの特性に応じて、次の3つの実装から選択できます。
|ハンドラ|説明|
|:---|:---|
|exec|コンテナ内のコマンドを実行する。</br>終了コードが0で終了すると、診断結果は成功とみなされます。</br>終了コードが0以外の場合の値では失敗とみなされます。|
|tcpSocket|指定したTCPポート番号に接続できれば、診断結果は成功とみなされます。|
|httpGet|指定したポートとパスに、HTTP GETが定期実行されます。</br>HTTPステータスコードが200以上400未満では成功とみなされ、それ以外は失敗とみなされます。</br>指定ポートが開いていない場合も失敗となります。|

## 7.4.3 ヘルスチェックの設定例
デフォルトの設定では、活性ブローブが3回連続で失敗すると、kubeletがコンテナを強制終了して再スタートさせます。
```
### FileName: webpal-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: webapl
spec:
  containers:
    - name: webapl
      image: webapl:0.1    # (1) ハンドラ実装済みアプリケーション
      livenessProbe:            # (2) 活性プローブに対するハンドラ設定
        httpGet:
          path: /healthz
          port: 3000
        initialDelaySeconds: 3  # 初回起動から探査開始までの猶予時間
        periodSeconds: 5        # チェック感覚
      readinessProbe:           # (3) 準備活性プローブに対するハンドラ設定
        httpGet:
          path: /ready
          port: 3000
        initialDelaySeconds: 15
        periodSeconds: 6
```
実際にコンテナを起動してプローブの動作を見ていきます。  
[ここ](https://github.com/takara9/codes_for_lessons/tree/master/step07/hc-probe)からもろもろ持ってきてください。
