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
      image: alallilianan/webapl:0.1              # (1) ハンドラ実装済みアプリケーション
      livenessProbe:                 # (2) 活性プローブに対するハンドラ設定
        httpGet:
          path: /healthz
          port: 3000
        initialDelaySeconds: 3       # 初回起動から探査開始までの猶予時間
        periodSeconds: 5             # チェック感覚
      readinessProbe:                # (3) 準備活性プローブに対するハンドラ設定
        httpGet:
          path: /ready
          port: 3000
        initialDelaySeconds: 15
        periodSeconds: 6
```
実際にコンテナを起動してプローブの動作を見ていきます。  
[ここ](https://github.com/takara9/codes_for_lessons/tree/master/step07/hc-probe)からもろもろ持ってきてください。
## 7.4.4 コンテナをビルドしてプッシュする
```
### ディレクトリをDockerfileのある場所に移りビルド
kube-master:~# docker build --tag alallilianan/webapl:0.1 .
```
```
### レジストリへログインしてプッシュ
kube-master:~# docker login
kube-master:~# docker push alallilianan/webapl:0.1
```
```
### ディレクトリを移動しマニフェストを適用
kube-master:~# cd ../
kube-master:~# kubectl apply -f webapl-pod.yaml
```
```
### ポッドが正常起動することを確認
kube-master:~# kubectl get pod
```
```
### ヘルスチェックの状態をコンテナのログから確認
kube-master:~# kubectl logs webapl
```
```
GET /healthz 200    ## LivenessProbeからアクセスがあったログ
GET /healthz 200    ## 間隔は5秒
GET /healthz 200
GET /ready 500      ## ReadinessProbeは20秒経過しておらず500を応答(失敗)
GET /healthz 200
GET /ready 200      ## 6秒後のReadinessProbeは成功なのでREADY 1/1に遷移、準備完了
```
```
### ポッドの詳細表示
kube-master:~# kubectl describe pod webapl
```
```
Name:         webapl
Namespace:    default
Priority:     0
Node:         kube-node02/192.168.137.4
Start Time:   Sun, 28 Mar 2021 11:27:41 +0000
Labels:       <none>
Annotations:  <none>
Status:       Running
IP:           10.244.2.29
IPs:
  IP:  10.244.2.29
Containers:
  webapl:
    Container ID:   docker://3f7118e5724d1cebdbb43f00db20f734aba6edd9176443d68994bcb51295cdef
    Image:          alallilianan/webapl:0.1
    Image ID:       docker-pullable://alallilianan/webapl@sha256:78d5cabb2339cf7154dfc089865461446daa57f28129d7d45f445dab9dfbb05d
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Sun, 28 Mar 2021 11:28:21 +0000
    Ready:          True    ### ReadinessProbeが成功したためTrueとなる
    Restart Count:  0       ### 以下、プローブの設定内容
    Liveness:       http-get http://:3000/healthz delay=3s timeout=1s period=5s #success=1 #failure=3
    Readiness:      http-get http://:3000/ready delay=15s timeout=1s period=6s #success=1 #failure=3
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-b76qc (ro)
<中略>
Events:
  Type     Reason     Age              From               Message
  ----     ------     ----             ----               -------
  Normal   Scheduled  91s              default-scheduler  Successfully assigned default/webapl to kube-node02
  Normal   Pulling    85s              kubelet            Pulling image "alallilianan/webapl:0.1"
  Normal   Pulled     57s              kubelet            Successfully pulled image "alallilianan/webapl:0.1" in 28.075762918s
  Normal   Created    53s              kubelet            Created container webapl
  Normal   Started    51s              kubelet            Started container webapl
  Warning  Unhealthy  35s              kubelet            Readiness probe failed: HTTP probe failed with statuscode: 500
  Warning  Unhealthy  2s (x2 over 7s)  kubelet            Liveness probe failed: HTTP probe failed with statuscode: 500
```
## 7.5 初期化専用コンテナ
ポッドの中には、初期化専用のコンテナを組み込むことができます。  
具体的には、リクエストを処理するコンテナと初期化だけに特化したコンテナで分けて開発します。
```
### FileName: init-sample.yaml
apiVersion: v1
kind: Pod
metadata:
  name: init-sample
spec:
  containers:
    - name: main              # メインコンテナ
      image: ubuntu
      command: ["/bin/sh"]
      args: ["-c", "tail -f /dev/null"]
      volumeMounts:
        - mountPath: /docs    # 共有ボリュームのマウントポイント
          name: data-vol
          readOnly: false

  initContainers:             # メインコンテナ実行前に初期化専用コンテナが動作する
    - name: init
      image: alpine
      ## 共有ボリュームにディレクトリを作成、オーナーを変更します
      command: ["/bin/sh"]
      args: ["-c", "mkdir /mnt/html; chown 33:33 /mnt/html"]
      volumesMounts:
        - mountPath: /mnt     # 共有ボリュームのマウントポイント
          name: data-vol
          readOnly: false

  volumes:                    # ポッド上の共有ボリューム
    - name; data-vol
      emptyDir: {}
```
