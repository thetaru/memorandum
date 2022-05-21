# マスターノードの構築
|ホスト名|IPアドレス|CPU数|搭載メモリ|役割|
|:---|:---|:---|:---|:---|
|k8s01|192.168.0.231|4|16GB|マスターノード(★)|
|k8s02|192.168.0.232|4|16GB|ワーカーノード|
|k8s03|192.168.0.233|4|16GB|ワーカーノード|

## ■ 事前準備
Ubuntu Serverの構築は済んでいるものとする。
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
以下の表にマスターノードで必要なポートのみ記載する。
|Protocol|Direction|Port Range|Purpose|Used By|
|:---|:---|:---|:---|:---|
|TCP|Inbound|6443|Kubernetes API server|All|
|TCP|Inbound|2379-2380|etcd server client API|kube-apiserver, etcd|
|TCP|Inbound|10250|Kubelet API|Self, Control plane|
|TCP|Inbound|10259|kube-scheduler|Self|
|TCP|Inbound|10257|kube-controller-manager|Self|

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

## ■ マスターノードのセットアップ
### コントロールプレーンノードの初期化
kubeadmクラスターをHAクラスタする予定がある場合、`--control-plane-endpoint`を指定する。  
エンドポイントには、名前解決可能なホスト名やロードバランサーの仮想IPアドレス(VIP)を指定できる。(※2)  
ここでは、内部DNSにDNSレコードを追加(k8s-masters.thetaru.homeで名前解決すると192.168.0.230のIPアドレスで解決させる)して対処する。  
  
CNI(Container Network Interface)プラグインは、flannelを使用する。  
ここでは、flannelのデフォルトのCIDR(10.244.0.0/16)を`--pod-network-cidr`に指定する。(※3)  
※2: DNSラウンドロビンやLBの負荷分散機能を利用する(ってことだと思う)  
※3: CNIについて調べられていない。また、各CNIプラグインの長所・短所も調べられていない。(用途ごとに変更する必要がある認識)
```sh
kubeadm init --control-plane-endpoint=k8s-masters.thetaru.home:6443 --pod-network-cidr=10.244.0.0/16
```
```sh
# 出力結果の最後のコマンドはひかえる(ワーカーノードがクラスタに参加する際に必要となる)
kubeadm join k8s-masters.thetaru.home:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

### ユーザの設定
非rootユーザの場合、以下のコマンドを実行する。
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
rootユーザの場合、以下のコマンドを実行する。
```sh
export KUBECONFIG=/etc/kubernetes/admin.conf && source ~/.bashrc
```
