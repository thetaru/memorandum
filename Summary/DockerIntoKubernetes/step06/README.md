# Kubernetes最初の一歩
## 6.1 クラスタ構成の確認
k8sクラスタが起動したら構成を確認します。  
手元の環境だと次のように出力されました。
```
# kubectl cluster-info
```
```
Kubernetes control plane is running at https://192.168.137.5:6443
KubeDNS is running at https://192.168.137.5:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
