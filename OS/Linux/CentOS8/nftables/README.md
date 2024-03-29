# nftables
シェルスクリプトを実行してnftableのルールを設定する
```sh
#!/bin/bash
###########################################################
# ルールファイルのパス
###########################################################
OUTPUT_FILE="/etc/nftables/rules.nft"

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
# サーバ共通で設定するルールを記載する
###########################################################
### 確立済みのパケット疎通は許可
nft add rule ip filter input ip protocol tcp ct state established,related counter accept
nft add rule ip filter input ip protocol udp ct state established,related counter accept

### 自分自身は許可
nft add rule ip filter input iifname "lo" counter accept

### Pingに応答する
nft add rule ip filter input ip protocol icmp counter accept

### e.g.
# nft add rule ip filter input ip saddr $HOSTNAME tcp dport 10050 counter accept

###########################################################
# 個別ルール
# サーバ毎に異なるルールを記載する
###########################################################
### e.g.
# nft add rule ip filter input ip saddr $LOCAL_NET tcp dport 22 counter accept

###########################################################
# 上記ルールに当てはまらなかったパケットはロギングしてDROP
# 出力先を変える場合は、syslogで拾うこと
###########################################################
nft add rule ip filter input counter log prefix \"\[nftables-dropped\]\: \"

###########################################################
# ルールを保存
###########################################################
nft list ruleset
nft list ruleset > $OUTPUT_FILE
```
## ルールの永続化
`/etc/sysconfig/nftables.conf`でルールをincludeする必要があります。
```
# vi /etc/sysconfig/nftables.conf
```
```
+  include /etc/nftables/rules.nft
```
サービスを再起動してルールが残っていることを確認する
```
# systemctl restart nftables
# nft list ruleset
```
