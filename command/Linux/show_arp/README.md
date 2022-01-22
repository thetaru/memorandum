# ARPテーブルの確認
MACアドレス(L2)とIPアドレス(L3)の対応表(ARPテーブル)を確認したいときに使う。
## ■ ARPテーブルの表示
`[エントリのIPアドレス] dev [自ホストのインターフェース名] lladdr [エントリのMACアドレス] (FAILED|STALE|REACHABLE)`の形式で表示される。
```
# ip [-4] neigh
```

## ■ エントリキャッシュの削除
```
# ip neigh flush <エントリのIPアドレス>
```
