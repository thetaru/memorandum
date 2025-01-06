# ワーカーノードの構築
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
swapoff -a
```
```sh
systemctl stop swap.target
systemctl mask swap.taget
```
`swap.target`がマスクされていることを確認する。
```sh
systemctl status swap.target
```
```
○ swap.target
     Loaded: masked (Reason: Unit swap.target is masked.)
     Active: inactive (dead)
```
`/etc/fstab`にswapをマウントする記載がある場合はそれも削除する。
```sh
sed -i.bak '/ swap / s/^/#/' /etc/fstab
diff -u /etc/fstab.bak /etc/fstab | grep -E "^(-|\+)"
```
再起動後、スワップが無効化されていることを確認する。
```sh
# 出力がないことを確認
swapon -s
```
> **Warning**  
> swapが有効の場合、`kubelet.service`が起動しないなどの影響がある。

### ノード間の名前解決ができることの確認
各ノードがDNSもしくはhostsにより、他ノードの名前解決ができるように設定する。  
以下にhostsの設定を記載する。
```diff
+ 192.168.0.231 k8s01 k8s01.thetaru.home.
+ 192.168.0.232 k8s02 k8s02.thetaru.home.
+ 192.168.0.233 k8s03 k8s03.thetaru.home.
```
> **Note**  
> DNSが落ちた場合を考えて、hostsにも登録するとよい。

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
lsmod | grep -E "^(overlay|br_netfilter)"
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
リポジトリの追加は、[CRIのインストール](https://kubernetes.io/ja/docs/setup/production-environment/container-runtimes/#containerd)を参照すること。
```sh
# containerdのインストール
apt-get update && apt-get install -y containerd.io
```

### containerd
cgroup v2を使用するため、systemd cgroupドライバーの設定を行う。
```sh
# containerdの設定をリセット
containerd config default > /etc/containerd/config.toml
```
```sh
vim /etc/containerd/config.toml
```
```diff
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
- SystemdCgroup = false
+ SystemdCgroup = true
```
設定の修正後、containerdサービスを再起動する。
```sh
systemctl restart containerd
```

## ■ kubeadm、kubelet、kubectlのインストール
リポジトリの追加は、[Installing kubeadm, kubelet and kubectl](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/_print/#installing-kubeadm-kubelet-and-kubectl)を参照すること。
```sh
# kubelet、kubeadm、kubectlをホールドする
apt-mark hold kubelet kubeadm kubectl
apt-mark showhold
```

## ■ 設定の反映
ワーカーノードのセットアップをする前に、OSを再起動する。
```sh
systemctl reboot
```

## ■ ワーカーノードのセットアップ
### ワーカーノードをクラスタに追加
マスターノードでkubeadm initを実行した際に出力されたコマンドを実行する。
```sh
kubeadm join k8s-masters.thetaru.home:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```
```
This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
