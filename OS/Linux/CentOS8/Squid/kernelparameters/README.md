# カーネルパラメータ
## fs.file-max
システム全体のファイルディスクリプタの最大値を設定する
## net.core.somaxconn
接続確立済み(ESTABLISHED状態のコネクション)キューの最大値を設定する
## net.core.netdev_max_backlog
各NICに対する受信パケットの処理待ちキューの最大値を設定する  
アクセス集中時(多数のパケットを受信時)にパケットを取りこぼさないようにするため
## net.ipv4.ip_local_port_range
動的ポートの範囲を設定する  
コネクション数が増加に伴い、ローカルポートが枯渇する可能性があるため
## net.ipv4.tcp_fin_timeout
ソケットを強制的にクローズする前に、最後のFINパケットを待つ時間を指定する  
コネクションの開放時間を短縮するため
## net.ipv4.tcp_keepalive_time
(1回目の)keepaliveパケットを送信するまでの時間を設定する  
死活監視の間隔(デフォルトは2時間)を短縮するため
## net.ipv4.tcp_keepalive_probes
keepaliveパケットを送信する回数を設定する  
死活監視の際にkeepaliveパケットを送信する回数を変更するため
## net.ipv4.tcp_keepalive_intvl
(2回目以降の)keepaliveパケットを送信する間隔を設定する  
死活監視の際にkeepaliveパケットを送信する間隔を変更するため
## net.ipv4.tcp_max_syn_backlog
接続確立中(SYN_RECIEVED状態のコネクション)キューの最大値を設定する  
アクセス集中時(多数のSYNパケットを受信時)にSYNパケットの取りこぼさないようにするため
## net.ipv4.tcp_max_tw_buckets

## net.ipv4.tcp_tw_reuse

# カーネルパラメータの反映
```
### デフォルトのカーネルパラメータを取得
# sysctl -a | sort > KernelParameters_$(date +%Y%m%d)

### 設定の反映
# sysctl -p
```
