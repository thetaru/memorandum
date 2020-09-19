# サービスの選定
サービスの起動がおせ～って時にみるといいです(参考になるhttps://milestone-of-se.nesuke.com/sv-basic/linux-basic/systemctl-list-dependencies/)
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
