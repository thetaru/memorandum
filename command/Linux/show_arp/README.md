# ARPテーブルの確認
MACアドレス(L2)とIPアドレス(L3)の対応表(ARPテーブル)を確認したいときに使う。
## ■ ARPテーブルの表示
`[IP-ADDR] dev [DEVICE-NAME] lladdr [MAC-ADDR] (FAILED|STALE|REACHABLE)`の形式で表示される。
```
# ip [-4] neigh
```

## ■ エントリキャッシュの削除
```
# ip neigh flush <ip-addr>
```
