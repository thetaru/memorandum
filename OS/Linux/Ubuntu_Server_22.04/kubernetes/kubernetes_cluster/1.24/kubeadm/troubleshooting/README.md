# トラブルシューティング
## CNI複数インストールしたとき
`/etc/cni/net.d/`配下の不要なCNIのコンフィグ削除する。
## flannelリソース再作成時
`ip link delete <flannel NIC>`でインターフェース削除
## kubeadm resetしたとき
cniが作る仮想NICを削除する。
