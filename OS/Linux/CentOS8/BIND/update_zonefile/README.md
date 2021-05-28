# ゾーンファイルの更新
ゾーンファイルの更新時にやるべきこと。  
## 1. named or named-chroot?
chrootを使っているかどうかを確認する。
```
# systemctl status named
# systemctl status named-chroot
```
ゾーンファイルの配置場所がわかった。  
以降、chroot環境下であっても起点は`/`として進める。  
※ `/var/named/chroot/etc/named.conf`でも`/etc/named.conf`と書くという意味。
## 2. named.conf
更新の際に見るべきポイントは次の通り。
- directoryオプション
> 設定ファイル内に相対パスで記述したときの基準となるファイルパスを指定する。
- zoneオプション
> ドメインとゾーンファイルを指定する。  
> typeがmasterとなっているもののみ更新の対象となる。(slaveの場合は上から降ってくため更新不要)  


