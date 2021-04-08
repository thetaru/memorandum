# ジョブとクーロンジョブ
ジョブはポッド内のすべてのコンテナが正常終了するまで、ポッドの再試行を繰り返すコントローラです。  
クーロンジョブはcronと同じフォーマットで、ジョブの定期実行時刻を設定できるコントローラです。  
## (1) ジョブの振る舞いと使用上の注意点
1. ジョブは、ポッドの実行回数と並行数を指定して、1つ以上のポッドを実行します。
2. ジョブは、ポッドが内包するすべてのコンテナが正常終了した場合に、ポッドを正常終了したものとして扱います。  
複数のコンテナのうち1つでも異常終了があれば、そのポッドを異常終了と見なします。
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
ジョブの終了状態を見るとステータスは正常終了となっていますが、詳細情報をみると再試行を繰り返してbackoffLimitに達していることがわかります。
```
kube-master:~/# kubectl get pod
```
```
NAME                   READY   STATUS      RESTARTS   AGE
two-containers-f8tg5   0/2     Completed   0          17m
two-containers-lbrtq   0/2     Completed   0          18m
two-containers-vvql8   0/2     Completed   0          18m
```
ジョブはポッド内のコンテナがすべて正常終了することをもって、ジョブが正常終了とみなすことがわかりました。
## 10.5 素数計算ジョブの作成と実行
[ここ](https://github.com/takara9/codes_for_lessons/tree/master/step10/job_prime_number)からファイル一式もってくること。(マニフェストにあるイメージは自分のアカウントにすること。)
```
kube-master:~/# docker build -t pn_generator .
kube-master:~/# docker login
kube-master:~/# docker tag pn_generator:latest alallilianan/pn_generator:0.1
kube-master:~/# docker push alallilianan/pn_generator
```
マニフェストを適用してジョブを作成します。
```
kube-master:~/# kubectl apply -f pn_job.yaml
```
```
kube-master:~/# kubectl get jobs
```
```
NAME           COMPLETIONS   DURATION   AGE
prime-number   1/1           4m33s      5m2s
```
ジョブの実行結果を参照するために、ジョブコントロール下で起動したポッドのログを参照します。
```
kube-master:~/# kubectl get pod
```
```
NAME                 READY   STATUS      RESTARTS   AGE
prime-number-wxdjl   0/1     Completed   0          7m25s
```
```
kube-master:~/# kubectl logs prime-number-wxdjl
```
```
[    2     3     5     7    11    13    17    19    23    29    31    37
    41    43    47    53    59    61    67    71    73    79    83    89
    <中略>
]
```
実務でジョブを利用する場合は、計算結果を他のプログラムから読み取れるようにするために、NoSQLDBやオブジェクトストレージへ保存するのがオススメです。
## 10.6 メッセージブローカーとの組み合わせ
ポッドがメッセージブローカーからパラメータを受け取れるようにします。  
マニフェストにパラメータを記述する必要がなくなりポッドごとに別のパラメータを渡せるのがよいです。
[ここ](https://github.com/takara9/codes_for_lessons/tree/master/step10/job_w_msg_broker)からファイル一式もってくること。(マニフェストにあるイメージは自分のアカウントにすること。
## 10.7 Kubernetes APIライブラリの利用
以下メモです。  
`job-initiator.py`の`qmgr_host`変数はk8sクラスタのノードのIPアドレス(どのノードでもよい)を指定します。  
修正箇所(job-initiator/Dockerfile)
```
# pyhon
RUN apt-get install -y python3 python3-pip
RUN pip3 install pika kubernetes
```
## 10.8 ジョブの投入と実行
`pn-generator-que`ディレクトリでイメージをビルドして、DockerHubへ登録します。
```
kube-master:~/# docker build --tag pn_generator:0.2 .
kube-master:~/# docker tag pn_generator:0.2 alalilianan/pn_generator:0.2
kube-master:~/# docker push alallilianan/pn_generator:0.2
```
### 10.8.1 RabbitMQのデプロイ
```
kube-master:~/# kubectl get node
kube-master:~/# kubectl apply -f taskQueue-deploy.yaml
kube-master:~/# kubectl get pod, services
```
```
NAME                             READY   STATUS    RESTARTS   AGE
pod/taskqueue-644dd99954-6klmh   1/1     Running   0          93s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/taskqueue    NodePort    10.102.170.31   <none>        5672:31672/TCP   101s
```
`job-initiator`のディレクトリで、コンテナのイメージをビルドします。
```
kube-master:~/# docker build --tag job-init:0.1 .
```
ビルドが完了したら、ビルドしたディレクトリでコンテナを起動します。  
コンテナ上から、ジョブを投入するコマンドjob-initiator.pyを実行します。
```
kube-master:~/# docker run -it --rm --name kube -v $(pwd)/py:py) -v ~/.kube:/root/.kube job-init:0.1 bash
```
```
### コンテナの中で実行
# cd /py; python3 job-initiator.py
```
別ターミナルでジョブの実行状態を確認します。
```
kube-master:~/# kubectl get jobs,pod
```
```
NAME              COMPLETIONS   DURATION   AGE
job.batch/pngen   4/4           7m         7m42s

NAME                             READY   STATUS      RESTARTS   AGE
pod/pngen-6vh6s                  0/1     Completed   0          7m40s
pod/pngen-bgdrr                  0/1     Completed   0          96s
pod/pngen-gc4hb                  0/1     Completed   0          93s
pod/pngen-zbd77                  0/1     Completed   0          7m40s
pod/taskqueue-644dd99954-6klmh   1/1     Running     0          62m
```
実行結果を見てみます。
```
kube-master:~/# kubectl logs pod/pngen-6vh6s
```
```
['1001', ' 2000']
[1009 1013 1019 1021 1031 1033 1039 1049 1051 1061 1063 1069 1087 1091
 1093 1097 1103 1109 1117 1123 1129 1151 1153 1163 1171 1181 1187 1193
 1201 1213 1217 1223 1229 1231 1237 1249 1259 1277 1279 1283 1289 1291
 1297 1301 1303 1307 1319 1321 1327 1361 1367 1373 1381 1399 1409 1423
 1427 1429 1433 1439 1447 1451 1453 1459 1471 1481 1483 1487 1489 1493
 1499 1511 1523 1531 1543 1549 1553 1559 1567 1571 1579 1583 1597 1601
 1607 1609 1613 1619 1621 1627 1637 1657 1663 1667 1669 1693 1697 1699
 1709 1721 1723 1733 1741 1747 1753 1759 1777 1783 1787 1789 1801 1811
 1823 1831 1847 1861 1867 1871 1873 1877 1879 1889 1901 1907 1913 1931
 1933 1949 1951 1973 1979 1987 1993 1997 1999 2003 2011 2017 2027 2029
 2039 2053 2063 2069 2081 2083 2087 2089 2099 2111 2113 2129 2131 2137
 2141 2143 2153 2161 2179 2203 2207 2213 2221 2237 2239 2243 2251 2267
 2269 2273 2281 2287 2293 2297 2309 2311 2333 2339 2341 2347 2351 2357
 2371 2377 2381 2383 2389 2393 2399 2411 2417 2423 2437 2441 2447 2459
 2467 2473 2477 2503 2521 2531 2539 2543 2549 2551 2557 2579 2591 2593
 2609 2617 2621 2633 2647 2657 2659 2663 2671 2677 2683 2687 2689 2693
 2699 2707 2711 2713 2719 2729 2731 2741 2749 2753 2767 2777 2789 2791
 2797 2801 2803 2819 2833 2837 2843 2851 2857 2861 2879 2887 2897 2903
 2909 2917 2927 2939 2953 2957 2963 2969 2971 2999]
```
ジョブを削除します。
```
kube-master:~/# kubectl get job
```
```
NAME    COMPLETIONS   DURATION   AGE
pngen   4/4           7m         10m
```
```
kube-master:~/# kubectl delete job pngen
```
```
job.batch "pngen" deleted
```
## 10.9 クーロンジョブ
スケジュールに従ってジョブを実行するコントローラです。  
マニフェストを見てみましょう。  
スケジュールの指定はUnixのクーロンと同じです。
```yaml
### FileName: cron-job.yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: hello
              image: busybox
              args:
                - /bin/sh
                - -c
                - date; echo Hello from the kubernetes cluseter
          restartPolicy: OnFailure
```
マニフェストを適用してクーロンジョブを作成します。
```
kube-master:~/# kubectl apply -f cron-job.yaml
```
クーロンジョブの実行状態を確認します。
```
kube-master:~/# kubectl get cronjobs
```
```
NAME    SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
hello   */1 * * * *   False     0        <none>          10s
```
1分毎にジョブが実行されていることを確認します。
```
kube-master:~/# kubectl get jobs
```
```
hello-1617176940   1/1           13s        2m49s
hello-1617177000   1/1           14s        106s
hello-1617177060   1/1           15s        53s
```
```
kube-master:~/# kubectl get pod
```
```
NAME                     READY   STATUS      RESTARTS   AGE
hello-1617177000-7w92d   0/1     Completed   0          2m25s
hello-1617177060-n5649   0/1     Completed   0          92s
hello-1617177120-s4n2d   0/1     Completed   0          31s
```
```
kube-master:~/# kubectl logs hello-1617177000-7w92d
```
```
Wed Mar 31 07:48:13 UTC 2021
Hello from the kubernetes cluseter
```
