# Nested ESXi
## memo
### ネストされるESXi
- /etc/vmware/configに`vhv.allow = "TRUE"`を追加し、`/etc/init.d/hostd restart`

### ネストするESXi
- 親ESXi上の仮想マシンの設定からCPU-`ハードウェア アシストによる仮想化をゲスト OS に公開`をON
