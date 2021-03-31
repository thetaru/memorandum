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
`parallelism: 2`を指定したことでポッドが2個ずつ実行されていることがわかります。
## 10.3 ジョブが異常終了するケース
