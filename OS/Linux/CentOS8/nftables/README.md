# nftables
シェルスクリプトを実行してnftableのルールを追加する
```sh
#!/bin/bash
###########################################################
# ネットワークの定義
###########################################################
# e.g.
# LOCAL_NET="192.168.137.0/24"

# ANY="0.0.0.0/0"

# ALLOW_HOSTS=(
#    "xxx.xxx.xxx.xxx"
#    "xxx.xxx.xxx.xxx"
#    "xxx.xxx.xxx.xxx"
# )

# DENY_HOSTS=(
#    "xxx.xxx.xxx.xxx"
#    "xxx.xxx.xxx.xxx"
#    "xxx.xxx.xxx.xxx"
# )

###########################################################
# ポートの定義
###########################################################

nft flush ruleset
nft add table ip filter
nft add chain ip filter input { type filter hook input priority 0 \; }
nft add rule ip protocol tcp ct state established,related counter
nft add rule ip protocol udp ct state established,related counter
nft add rule ip filter input ip protocol icmp counter accept
nft add rule ip filter input ip saddr 192.168.137.0/24 tcp dport 22 counter accept
nft add rule ip filter input ip saddr 192.168.137.1/32 udp dport 55 counter accept
nft add rule ip filter input ip saddr 192.168.137.22/32 tcp dport 10050 counter accept
nft add rule ip filter input counter log prefix \"\[nftables-dropped\]\: \"
nft add chain ip filter input { type filter hook input priority 0 \; policy drop \; }
nft list ruleset
```
