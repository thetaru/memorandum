# トラブルシューティング
## CNI複数インストールしたとき
`/etc/cni/conf.d`配下の不要なCNIのコンフィグ削除する。
## kubeadm resetしたとき
cniが作る仮想NICを削除する。
