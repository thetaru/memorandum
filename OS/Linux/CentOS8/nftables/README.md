# nftables
シェルスクリプトを実行してnftableのルールを追加する
```sh
#!/bin/bash
###########################################################
# ネットワークの定義
###########################################################
### e.g.
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

# HOSTNAME=192.168.137.10

###########################################################
# ポートの定義
###########################################################
SSH=22
DNS=52
HTTP=80
HTTPS=443
NTP=123

###########################################################
# nftablesの初期化
###########################################################
nft flush ruleset

###########################################################
# ポリシーの決定
###########################################################
### テーブル作成
nft add table ip filter

### INPUT: DROP
nft add chain ip filter input { type filter hook input priority 0 \; policy drop \; }

### OUTPUT: ACCEPT
nft add chain ip filter output { type filter hook output priority 0 \; }

### FORWARD: DROP
nft add chain ip filter forward { type filter hook forward priority 0 \; policy drop \; }

###########################################################
# 共通ルール
###########################################################
### 確立済みのパケット疎通は許可
nft add rule ip filter input ip protocol tcp ct state established,related counter accept
nft add rule ip filter input ip protocol udp ct state established,related counter accept

### 自分自身は許可
nft add rule ip filter input iifname "lo" counter accept

### Pingに応答する
nft add rule ip filter input ip protocol icmp counter accept

### e.g.
# nft add rule ip filter input ip saddr $ZABBIX_SRV tcp dport 10050 counter accept

###########################################################
# 個別ルール
###########################################################
### e.g.
# nft add rule ip filter input ip saddr $LOCAL_NET tcp dport 22 counter accept

###########################################################
# 上記ルールに当てはまらなかったパケットはロギングしてDROP
###########################################################
nft add rule ip filter input counter log prefix \"\[nftables-dropped\]\: \"

###########################################################
# ルールを保存
###########################################################
nft list ruleset
```
