# カーネルパラメータのチューニング
## コネクションテーブル(nf_conntrack)の拡張
まずは現在のコネクション数と最大値を確認します。
```
### 現在のコネクション数
# cat /proc/sys/net/netfilter/nf_conntrack_count 
2

### コネクションテーブルの最大値
# cat /proc/sys/net/netfilter/nf_conntrack_max 
65536
```
  
nf_conntrackでは、1コネクションあたり約300~400バイトのメモリを消費します。  
そのため、Squidサーバに搭載しているメモリ容量を考慮して値を決定する必要があります。
```
# vi /etc/sysctl.conf
```
```
### 例として500000と設定していますが環境に応じて変更してください
+  net.netfilter.nf_conntrack_max = 500000
```
パラメータを反映させます。
```
# sysctl -p
```
