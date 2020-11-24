# OOM-Killerについて
## ■ OOM Killerの動作
メモリが不足してシステムが停止する恐れがある際、メモリリソースを多く消費しているプロセスを強制的に停止させます。

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
https://aegif.jp/alfresco/tech-info/-/20201119-alfresco/1.1?redirect=%2Fweb%2Faegif-labo-blog-alfresco
