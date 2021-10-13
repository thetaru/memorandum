# カーネルパラメータ
## fs.file-max
## net.core.somaxconn
## net.core.netdev_max_backlog
## net.ipv4.ip_local_port_range
## net.ipv4.tcp_fin_timeout
## net.ipv4.tcp_keepalive_time
## net.ipv4.tcp_keepalive_probes
## net.ipv4.tcp_keepalive_intvl
## net.ipv4.tcp_max_syn_backlog
## net.ipv4.tcp_max_tw_buckets
## net.ipv4.tcp_tw_reuse

# カーネルパラメータの反映
```
### デフォルトのカーネルパラメータを取得
# sysctl -a | sort > KernelParameters_$(date +%Y%m%d)

### 設定の反映
# sysctl -p
```
