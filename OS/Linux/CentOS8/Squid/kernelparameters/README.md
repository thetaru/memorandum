# ■ カーネルパラメータ
## fs.file-max
システム全体のファイルディスクリプタの最大値を設定する
## net.core.somaxconn
接続確立済みのコネクション(ESTABLISHED状態のコネクション)を格納するキューの最大長を設定する
## net.core.netdev_max_backlog
各NICに対する受信パケットの処理待ちキューの最大長を設定する  
アクセス集中時(多数のパケットを受信時)にパケットを取りこぼさないようにするため
## net.ipv4.ip_local_port_range
動的ポートの範囲を設定する  
コネクション数が増加に伴い、ローカルポートが枯渇する可能性があるため
## net.ipv4.tcp_fin_timeout
ソケットを強制的にクローズする前に、最後のFINパケットを待つ時間を指定する  
コネクションの開放時間を短縮するため  
※ FIN-WAIT2からTIME_WAIT遷移する時間の設定
## net.ipv4.tcp_keepalive_time
(1回目の)keepaliveパケットを送信するまでの時間を設定する  
死活監視の間隔(デフォルトは2時間)を短縮し、CLOSE_WAIT状態のコネクションを減らすため
## net.ipv4.tcp_keepalive_probes
keepaliveパケットを再送する回数を設定する  
死活監視の際にkeepaliveパケットを再送する回数を変更するため
## net.ipv4.tcp_keepalive_intvl
(2回目以降の)keepaliveパケットを送信する間隔を設定する  
死活監視の際にkeepaliveパケットを送信する間隔を変更するため
## net.ipv4.tcp_max_syn_backlog
SYN受信済みのコネクション(SYN_RECIEVED状態のコネクション)を格納するキューの最大長を設定する  
アクセス集中時(多数のSYNパケットを受信時)にSYNパケットの取りこぼさないようにするため
## net.ipv4.tcp_max_tw_buckets
TIME_WAIT状態のコネクションが同時に存在できる最大値を設定する  
TIME_WAIT状態のコネクション総数が最大数と等しい場合、次にTIME_WAIT状態に遷移すべきコネクションは破棄されてしまうため  
※ ただし、コネクションはローカルポートを使用するため、利用可能なローカルポート数以下に設定すること
## net.ipv4.tcp_tw_reuse
TIME_WAIT状態のコネクションを再利用するかを設定する  
ただし、再利用する際は以下の条件がある
1. 送信元アドレス、送信元ポート、送信先アドレス、送信先ポートが一致している
2. TCP Timestamp Optionが有効な接続

※ TCP Timestamp Optionが有効であることは、`net.ipv4.tcp_timestamps = 0`から確認できる

# ■ カーネルパラメータの反映
```
### デフォルトのカーネルパラメータを取得
# sysctl -a | sort > KernelParameters_$(date +%Y%m%d).old

### 設定の反映
# sysctl -p

### 設定の確認
# sysctl -a | sort > KernelParameters_$(date +%Y%m%d).new

### 差分確認(動的なパラメータもあるので余計な情報も出力される)
# diff KernelParameters_$(date +%Y%m%d).{old,new}
```
