# k8s
# 環境
|ホスト名|IPアドレス|
|:---|:---|
|kube-master|192.168.137.100|
|kube-node1|192.168.137.101|
|kube-node2|192.168.137.102|
# 構築ログ
# docker Install
https://docs.docker.com/engine/install/ubuntu/
# k8s Install
## kubeadm Install
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
```
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```
