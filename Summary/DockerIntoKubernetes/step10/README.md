# ジョブとクーロンジョブ
ジョブはポッド内のすべてのコンテナが正常終了すまで、ポッドの再試行を繰り返すコントローラです。  
クーロンジョブはcronと同じフォーマットで、ジョブの定期実行時刻を設定できるコントローラです。  
## (1) ジョブの振る舞いと使用上の注意点
1. ジョブは、ポッドの実行回数と並行数を指定して、1つ以上のポッドを実行します。
2. ジョブは、ポッドが内包するすべてのコンテナが正常終了した場合に、ポッドを正常終了したものとして扱います。  
複数のコンテナのうち1つでも異常終了があれば、そのポッドを異常終了と見なされます。
3. ジョブに記述したポッドの実行回数がすべて正常終了すると、ジョブは完了します。  
また、ポッドが異常終了による再試行上限に達すると、ジョブは中断します。
4. ノード障害などにより、ジョブのポッドが実行中に失われた場合、ジョブは他のノードでポッドを再スタートします。
5. ジョブによって実行されたポッドは、ジョブが削除されるまで保持されます。  
ジョブを削除すると、起動されたすべてのポッドが削除された。

## (2) 時刻でポットを制御するクーロンジョブ
クーロンジョブは設定された時刻にジョブを生成します。(時刻指定でジョブを実行します。)  
クーロンジョブの制御化で起動したポッドが、決められた保存世代数を越えるとクーロンジョブはガーベッジコレクションと呼ばれるコントローラを使い、終了済みのポッドを削除します。
## 10.1 ジョブ適用のユースケース
とばし
## 10.2 ジョブの同時実行数と実行回数
ポッドの実行回数(Completions)と実行数(Parallelism)を指定した場合の振る舞いを見てみます。
次はジョブのマニフェストです。
```
### FileName: job-normal-end.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: normal-job
spec:
  template:
    spec:
      containers:
        - name: busybox
          image: busybox:latest
          command: ["sh", "-c", "sleep 5; exit 0"]
      restartPolicy: Never
  completions: 6
  # parallelism: 2
```
マニフェストを適用してジョブを作成します。
```
kube-master:~/# kubectl apply -f job-normal-end.yaml
```
ジョブの状態確認
```
kube-master:~/# kubectl get jobs
```
```
NAME         COMPLETIONS   DURATION   AGE
normal-job   6/6           2m50s      2m53s
```
ジョブの詳細確認
```
kube-master:~/# kubectl describe job normal-job
```
```
Name:           normal-job
Namespace:      default
<中略>
Parallelism:    1
Completions:    6
<中略>
Events:
  Type    Reason            Age    From            Message
  ----    ------            ----   ----            -------
  Normal  SuccessfulCreate  4m46s  job-controller  Created pod: normal-job-dw2w8
  Normal  SuccessfulCreate  4m14s  job-controller  Created pod: normal-job-c8bbt
  Normal  SuccessfulCreate  3m47s  job-controller  Created pod: normal-job-p8zxm
  Normal  SuccessfulCreate  3m16s  job-controller  Created pod: normal-job-jj4rl
  Normal  SuccessfulCreate  2m50s  job-controller  Created pod: normal-job-f8mmt
  Normal  SuccessfulCreate  2m22s  job-controller  Created pod: normal-job-d4gqz
  Normal  Completed         116s   job-controller  Job completed
```
マニフェスト`job-normal-end.yaml`を編集して`parallelism: 2`をアンコメントして適用します。
```
### ジョブの削除と作成
kube-master:~/# kubectl delete -f job-normal-end.yaml
kube-master:~/# kubectl apply -f job-normal-end.yaml
```
```
kube-master:~/# kubectl describe job normal-job
```
```
Name:           normal-job
Namespace:      default
<中略>
Parallelism:    2
Completions:    6
<中略>
Events:
  Type    Reason            Age    From            Message
  ----    ------            ----   ----            -------
  Normal  SuccessfulCreate  4m35s  job-controller  Created pod: normal-job-ght4z
  Normal  SuccessfulCreate  4m35s  job-controller  Created pod: normal-job-x4c49
  Normal  SuccessfulCreate  4m5s   job-controller  Created pod: normal-job-lptpn
  Normal  SuccessfulCreate  3m54s  job-controller  Created pod: normal-job-jsskt
  Normal  SuccessfulCreate  3m23s  job-controller  Created pod: normal-job-v8tw9
  Normal  SuccessfulCreate  3m12s  job-controller  Created pod: normal-job-gngt7
  Normal  Completed         2m39s  job-controller  Job completed
```
`parallelism: 2`を指定したことでポッドが2個ずつ実行されていることがわかります。
## 10.3 ジョブが異常終了するケース
ポッドのコンテナが異常終了するときのジョブの振る舞いを見ていきます。  
```yaml
### FileName: job-abnormal-end.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: abnormal-end
spec:
  backoffLimit: 3
  template:
    spec:
      containers:
        - name: busybox
          image: busybox:latest
          command: ["sh", "-c", "sleep 5; exit 1"]
      restartPolicy: Never
```
このマニフェストを適用します。
```
kube-master:~/# kubectl apply -f job-abnormal-end.yaml
```
ジョブを確認します。
```
kube-master:~/# kubectl get jobs
```
```
NAME           COMPLETIONS   DURATION   AGE
abnormal-end   0/1           5m1s       5m1s
```
異常終了ジョブの詳細を表示します。  
Eventsの最後にbackoffLimitに達するまでの3回、合計4回の起動が実行されていることがわかります。
```
kube-master:~/# kubectl describe jobs abnormal-end
```
```
Name:           abnormal-end
Namespace:      default
Selector:       controller-uid=40c705d8-01ab-4706-b110-95f16c7fcbe7
Labels:         controller-uid=40c705d8-01ab-4706-b110-95f16c7fcbe7
                job-name=abnormal-end
Annotations:    <none>
Parallelism:    1
Completions:    1
Start Time:     Wed, 31 Mar 2021 04:18:31 +0000
Pods Statuses:  0 Running / 0 Succeeded / 4 Failed
Pod Template:
  Labels:  controller-uid=40c705d8-01ab-4706-b110-95f16c7fcbe7
           job-name=abnormal-end
  Containers:
   busybox:
    Image:      busybox:latest
    Port:       <none>
    Host Port:  <none>
    Command:
      sh
      -c
      sleep 5; exit 1
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Events:
  Type     Reason                Age    From            Message
  ----     ------                ----   ----            -------
  Normal   SuccessfulCreate      2m29s  job-controller  Created pod: abnormal-end-vfspm
  Normal   SuccessfulCreate      2m6s   job-controller  Created pod: abnormal-end-fqvj2
  Normal   SuccessfulCreate      90s    job-controller  Created pod: abnormal-end-j2b7m
  Normal   SuccessfulCreate      43s    job-controller  Created pod: abnormal-end-kbjl4
  Warning  BackoffLimitExceeded  2s     job-controller  Job has reached the specified backoff limit
```
## 10.4 コンテナの異常終了とジョブ
ジョブから起動されるポッド上のコンテナの1つが異常終了となったときの、ジョブの振る舞いを確認します。
```yaml
### FileName: job-container-failed.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: two-containers
spec:
  template:
    spec:
      containers:
        - name: busybox1
          image: busybox:1
          command: ["sh", "-c", "sleep 5; exit 0"]
        - name: busybox2
          image: busybox:1
          command: ["sh", "-c", "sleep 5; exit 1"]
      restartPolicy: Never
  backoffLimit: 2
```
マニフェストを適用します。
```
kube-master:~/# kubectl apply -f job-container-failed.yaml
```
ジョブの詳細情報を表示します。
```
kube-master:~/# kubectl describe jobs two-containers
```
```
Name:           two-containers
Namespace:      default
<中略>
Events:
  Type     Reason                Age    From            Message
  ----     ------                ----   ----            -------
  Normal   SuccessfulCreate      2m15s  job-controller  Created pod: two-containers-lbrtq
  Normal   SuccessfulCreate      111s   job-controller  Created pod: two-containers-vvql8
  Normal   SuccessfulCreate      76s    job-controller  Created pod: two-containers-f8tg5
  Warning  BackoffLimitExceeded  7s     job-controller  Job has reached the specified backoff limit
```
