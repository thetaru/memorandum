# ワーカーノードの構築
|ホスト名|IPアドレス|CPU数|搭載メモリ|役割|
|:---|:---|:---|:---|:---|
|k8s01|192.168.0.231|4|16GB|マスターノード|
|k8s02|192.168.0.232|4|16GB|ワーカーノード(★)|
|k8s03|192.168.0.233|4|16GB|ワーカーノード(★)|

## ■ 事前準備
Ubuntu Serverの構築は済んでいるものとする。(また、apparmorは無効化しておくこと)
### スワップ領域の無効化
kubeletが正常動作するために、swapをオフにする必要がある。  
そのため、OSインストール時に必要以上にスワップ領域を確保する必要はない。
```sh
# スワップ領域がsystemd管理下にある場合
systemctl --type swap
systemctl mask --now XXX.swap
```
※ systemd管理ではない場合、`swapoff -a`したあと、fstabからswapの記述をコメントアウトする

### ノード間の名前解決ができることの確認
各ノードがDNSもしくはhostsにより、他ノードの名前解決ができるように設定する。  
以下にhostsの設定を記載する。
```
192.168.0.231 k8s01 k8s01.thetaru.home.
192.168.0.232 k8s02 k8s02.thetaru.home.
192.168.0.233 k8s03 k8s03.thetaru.home.
```
※ DNSが落ちた場合を考えると、hostsに登録するのが無難かもしれない

### ファイアウォールの設定
iptablesをインストールしていない場合は、以下のコマンドからインストールを行うこと。
```sh
# iptablesのインストール
apt install iptables iptables-persistent

# iptablesサービスの自動起動を有効化
systemctl enable --now iptables
```
Kuberneteが使用するポート番号を[Ports and Protocols](https://kubernetes.io/docs/reference/ports-and-protocols/)より抜粋する。  
以下の表にワーカーノードで必要なポートのみ記載する。
|Protocol|Direction|Port Range|Purpose|Used By|
|:---|:---|:---|:---|:---|
|TCP|Inbound|10250|Kubelet API|Self, Control plane|
|TCP|Inbound|30000-32767|NodePort Services|All|

## ■ CRI(Container Runtime Interface)のインストール
CRIは、kubeletがコンテナランタイムを操作するためのプラグインインターフェースである。  
Kubernetesは、Podのコンテナを実行するために、コンテナランタイムを使用する。  
ここでは、コンテナランタイムにcontainerdを使用する。
### カーネルモジュールの設定
起動時にロードするカーネルモジュール(overlay,br_netfilter)を`/etc/modules-load.d/containerd.conf`に記載する。
```sh
cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
```
カーネルモジュール(overlay,br_netfilter)のロードする。
```sh
modprobe overlay
modprobe br_netfilter
```
カーネルモジュール(overlay,br_netfilter)がロードされていることを確認する。
```sh
lsmod | egrep "^(overlay|br_netfilter)"
```

### カーネルパラメータの設定
Kubernetesでは、
- iptablesがネットワークブリッジを通過するパケットを処理できること
- IPフォワーディングを有効にすること

が必要であるため、以下のパラメータを設定する。
```sh
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
設定ファイル`/etc/sysctl.d/99-kubernetes-cri.conf`をロードする。
```sh
sysctl -p /etc/sysctl.d/99-kubernetes-cri.conf
```
カーネルパラメータが設定されていることを確認する。
```sh
sysctl net.bridge.bridge-nf-call-iptables
sysctl net.ipv4.ip_forward
sysctl net.bridge.bridge-nf-call-ip6tables
```

### Containerdのインストール
以下、[CRIのインストール](https://kubernetes.io/ja/docs/setup/production-environment/container-runtimes/#containerd)に記載の手順を抜粋した。    
(apt-keyは非推奨とのことだったので修正した。)
```sh
# リポジトリの設定
apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release
```
```sh
# Docker公式のGPG鍵を追加
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
```sh
# Dockerのaptリポジトリの追加
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
```sh
# containerdのインストール
apt-get update && apt-get install -y containerd.io
```
```sh
# containerdの設定
mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
```
```sh
# containerdの再起動
systemctl restart containerd
```
```sh
# containerdの起動確認
systemctl status containerd
```

## ■ kubeadm、kubelet、kubectlのインストール
以下、[Installing kubeadm, kubelet and kubectl](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/_print/#installing-kubeadm-kubelet-and-kubectl)に記載の手順を抜粋した。
```sh
# リポジトリの設定
apt-get update
apt-get install -y apt-transport-https ca-certificates curl
```
```sh
# GoogleのGPG鍵を追加
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
```
```sh
# Kubernetesのaptリポジトリの追加
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
```sh
# kubelet、kubeadm、kubectlをインストールし、バージョンを固定する(※1)
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
```
※1: [kubeadmクラスタのアップグレード](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)は特別な手順があるため、aptによるアップグレードは行わない
```sh
# kubelet、kubeadm、kubectlがホールドされていることを確認する
apt-mark showhold
```

## ■ cgroupドライバの設定
以下、[Configuring a cgroup driver](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/configure-cgroup-driver/)に記載の手順を抜粋した。
### containerd
containerdがcgroupドライバにsystemdを利用するように設定する。
```sh
vim /etc/containerd/config.toml
```
```
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = true
```
設定の修正後、containerdサービスを再起動する。
```sh
systemctl restart containerd
```

### kubelet
kubeletがcgroupドライバにsystemdを利用するように設定する。
```sh
kubectl edit cm kubelet-config -n kube-system
```
```
cgroupDriver: systemd
```
設定の修正後、kubeletサービスを再起動する。
```sh
systemctl daemon-reload && systemctl restart kubelet
```

## ■ ワーカーノードのセットアップ
### ワーカーノードをクラスタに追加
マスターノードで`kubeadm init`を実行した際に出力されたコマンドを実行する。
```sh
kubeadm join k8s-masters.thetaru.home:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```
```
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
