# k8s
# 環境
|ホスト名|IPアドレス|
|:---|:---|
|kube-master|192.168.137.100|
|kube-node1|192.168.137.101|
|kube-node2|192.168.137.102|
# 構築ログ
# OS設定
## swapの無効化
```
$ sudo swapoff -a
```
# docker Install
https://docs.docker.com/engine/install/ubuntu/
```
$ sudo apt-get update

$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo apt-key fingerprint 0EBFCD88
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
$ docker --version
```
# k8s Install
## kubelet kubeadm kubectl Install
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
```
$ sudo apt-get update && sudo apt-get install -y apt-transport-https curl
$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
$ cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
  deb https://apt.kubernetes.io/ kubernetes-xenial main
  EOF
$ sudo apt-get update
$ sudo apt-get install -y kubelet kubeadm kubectl
$ sudo apt-mark hold kubelet kubeadm kubectl
```
## Masterの設定
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
```
$ kubeadm init --pod-network-cidr=10.244.0.0/16
```
```
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
## Nodeの設定
