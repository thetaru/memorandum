# Nested ESXi
## memo
### ネストされるESXi
- /etc/vmware/configにvhv.allow = "TRUE"を追加

### ネストするESXi
- 親ESXi上の仮想マシンの設定からCPU-`ハードウェア アシストによる仮想化をゲスト OS に公開`をON
