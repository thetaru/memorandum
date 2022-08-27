# マスターノードの構築
|ホスト名|IPアドレス|CPU数|搭載メモリ|役割|
|:---|:---|:---|:---|:---|
|k8s01|192.168.0.231|4|16GB|マスターノード(★)|
|k8s02|192.168.0.232|4|16GB|ワーカーノード|
|k8s03|192.168.0.233|4|16GB|ワーカーノード|

## ■ 事前準備
Ubuntu Serverの構築は済んでいるものとする。(また、apparmorは無効化しておくこと)
### スワップ領域の無効化
kubeletが正常動作するために、swapをオフにする必要がある。  
そのため、OSインストール時に必要以上にスワップ領域を確保する必要はない。
```sh
# 一時的にスワップを無効にする
sudo swapoff -a
```
```sh
# swapが存在するデバイスを選択する(ここでは、/dev/sdaとしている)
sudo fdisk /dev/sda
```
```
Command (m for help): print
Device        Start       End   Sectors Size Type
/dev/sda1      2048      4095      2048   1M BIOS boot
/dev/sda2      4096   2101247   2097152   1G Linux filesystem
/dev/sda3   2101248  10489855   8388608   4G Linux swap
/dev/sda4  10489856 209713151 199223296  95G Linux filesystem

Command (m for help): t
Partition number (1-4, default 4): 3 (/dev/sda3がswapなので3を選択する)
Partition type or alias (type L to list all): L
 19 Linux swap                     0657FD6D-A4AB-43C4-84E5-0933C84B4F4F
 20 Linux filesystem               0FC63DAF-8483-4772-8E79-3D69D8477DE4
Partition type or alias (type L to list all): 20

Changed type of partition 'Linux swap' to 'Linux filesystem'.

Command (m for help): print
Device        Start       End   Sectors Size Type
/dev/sda1      2048      4095      2048   1M BIOS boot
/dev/sda2      4096   2101247   2097152   1G Linux filesystem
/dev/sda3   2101248  10489855   8388608   4G Linux filesystem
/dev/sda4  10489856 209713151 199223296  95G Linux filesystem

Command (m for help): w
```
OS起動時にマウントしないようにswap領域をコメントアウトする。
```sh
sudo vim /etc/fstab
```
```
#/dev/disk/by-uuid/667a4e52-34e7-4803-a29a-6db36f152212 none swap sw 0 0
#/swap.img      none    swap    sw      0       0
```
※ swapが有効の場合、`kubelet.service`が起動しないなどの影響がある。

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
iptablesのポリシーを変更する。
```sh
apt install iptables arptables ebtables
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy
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

### GRUBの設定
cgroupv2(デフォルト)からcgroupv1へ切り替える。
```sh
vim /etc/default/grub
```
```
GRUB_CMDLINE_LINUX_DEFAULT="systemd.unified_cgroup_hierarchy=false"
```
パラメータを反映する。
```sh
sudo update-grub
```

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
kubeletサービスのユニットファイルは`/var/lib/kubelet/config.yaml`を参照しているので、このファイルを修正する。
```sh
mkdir -p /var/lib/kubelet
vim /var/lib/kubelet/config.yaml
```
```
cgroupDriver: systemd
```
設定の修正後、kubeletサービスを再起動する。
```sh
systemctl daemon-reload && systemctl restart kubelet
```

## ■ kubeletの設定
### ノードIPの設定
kubeletがプライマリネットワークインターフェイスを自動検知しないよう手動で設定する。  
※ ノードごとにIPアドレスを設定すること
```sh
vim /etc/default/kubelet
```
```
KUBELET_EXTRA_ARGS="--node-ip=192.168.0.231"
```
kubeletサービスの再読み込みと再起動を行う。
```sh
systemctl daemon-reload && systemctl restart kubelet.service
```
psコマンドでkubeletプロセスを確認し、`--node-ip=x.x.x.x`オプションがあることを確認する。
```sh
ps -fup $(pgrep kubelet) -ww
```

### 名前解決の設定
kubeletが名前解決の際に利用する`resolv.conf`を指定する。
```sh
vim /etc/default/kubelet
```
```
KUBELET_EXTRA_ARGS="--resolv-conf=/run/systemd/resolve/resolv.conf"
```
kubeletサービスの再読み込みと再起動を行う。
```sh
systemctl daemon-reload && systemctl restart kubelet.service
```
psコマンドでkubeletプロセスを確認し、`--resolv-conf=/run/systemd/resolve/resolv.conf`オプションがあることを確認する。
```sh
ps -fup $(pgrep kubelet) -ww
```

## ■ マスターノードのセットアップ
### コントロールプレーンノードの初期化
kubeadmクラスターをHAクラスタする予定がある場合、`--control-plane-endpoint`を指定する。  
エンドポイントには、名前解決可能なホスト名やロードバランサーの仮想IPアドレス(VIP)を指定できる。(※2)  
ここでは、内部DNSにレコードを追加(k8s-masters.thetaru.homeで名前解決すると192.168.0.231を返すようにする)して対処する。  
  
CNI(Container Network Interface)プラグインは、flannelを使用する。  
ここでは、flannelのデフォルトのCIDR(10.244.0.0/16)を`--pod-network-cidr`に指定する。(※3)  
※2: DNSラウンドロビンやLBの負荷分散機能を利用する(ってことだと思う)  
※3: CNIについて調べられていない。また、各CNIプラグインの長所・短所も調べられていない。(用途ごとに変更する必要がある認識)
```sh
kubeadm init --control-plane-endpoint=k8s-masters.thetaru.home:6443 --pod-network-cidr=10.244.0.0/16
```
※ Preflight checkでエラーがでたら、`kubeadm reset`で実行後に再度`kubeadm init`で初期化を行うとよい。
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
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc
source ~/.bashrc
```

### CNIプラグインのインストール
#### flannel
各ノードの`/opt/bin/flanneld/`配下に[flanneldバイナリ](https://github.com/flannel-io/flannel/releases)を配置する。
```sh
mkdir -p /opt/bin
wget -O - https://github.com/flannel-io/flannel/releases/download/<version>/flannel-<version>-linux-<arch>.tar.gz | tar zxvf - -C /opt/bin flanneld
chown root:root /opt/bin/flanneld
```
flannelリソースを作成する。
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

#### Calico
```sh
kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml
```
```sh
wget https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml
```
`spec.calicoNetwork.ipPools`の`cidr`をPodネットワークのセグメント(`kubeadm init`のオプション`pod-network-cidr`への引数)に変更する。  
※ ここでは、`10.244.0.0/16`を指定する。
```sh
vim custom-resources.yaml
```
```yaml
cidr: 10.244.0.0/16
```
Calicoのリソースを作成する。
```sh
kubectl create -f custom-resources.yaml
```
