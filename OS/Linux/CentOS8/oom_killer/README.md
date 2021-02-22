# OOM-Killerについて
## ■ OOM Killerの動作
メモリが不足してシステムが停止する恐れがある際、メモリリソースを多く消費しているプロセスを強制的に停止させます。  
何でもかんでもメモリ使用率の高いプロセスが停められてしまうのはシステムの運用上困るので優先度を決めることができます。  
プロセスの優先度は`/proc/<PID>/oom_score_adj`、スコアは`/proc/<PID>/oom_score`で確認できます。  
優先度は低いほど止められにくく、高いほど止められやすいです。  
## ■ ヤられないためには
### systemdの場合
```
### 例としてhttpdを扱います
# vi /etc/systemd/system/httpd.service
```
```
...
[Service]
...
### Serviceディレクティブに追加します
OOMScoreAdjust=-1000
...
```
```
### サービスの再読み込み
# systemctl daemon-reload
# systemctl restart httpd
```
設定が反映されていることを確認する。
```
# cat /proc/`pgrep --parent 1 -f httpd`/oom_score_adj
```
```
-1000
```
```
# cat /proc/`pgrep --parent 1 -f httpd`/oom_score
```
```
0
```
