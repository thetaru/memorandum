# VirtualBox
## ■ 前提条件
CentOS: 8  
VirtualBox: 6.1.18
## ■ Install
VirtualBoxの[公式ページ](https://www.virtualbox.org/wiki/Linux_Downloads)よりrpmファイル(VirtualBox-6.1-6.1.18_142142_el8-1.x86_64.rpm)をダウンロードします。  
インターネットに接続できる環境ならyumで依存関係を解決できます。
```
# yum install VirtualBox-6.1-6.1.18_142142_el8-1.x86_64.rpm
```
## ■ よくある設定
### NATネットワーク
建てたVMを外とやり取りさせたい場合がほとんどだと思うので設定します。  
`ファイル`-`環境設定`-`ネットワーク`より`新しいNATネットワークを追加`を選択します。  
ネットワーク名: <NAT_NETWORK_NAME>  
ネットワークCIDR: <NAT_NETWORK_CIDR>
ネットワークオプション: [] DHCPのサポート [ ] IPv6サポート
