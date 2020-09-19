# サービスの選定
## 起動時間のチェック
```
$ systemd-analyze
```
## プロセス毎の起動時間
```
$ systemd-analyze blame
```
## プロセスの選出
```
$ systemd-analyze critical-chain
```
