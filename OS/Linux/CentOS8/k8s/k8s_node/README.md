# k8sノードの構築
## ■ swapの無効化
swap領域を確保している場合は次のようにして無効化する。  
swapファイルを作成している場合は別に操作が必要となるがここでは説明しない。
```
# swapoff -a
```
```
# vi /etc/fstab
```
```
-  UUID=<UUID> none                    swap    defaults        0 0
+  #UUID=<UUID> none                    swap    defaults        0 0
```
## ■ hostsの追加
```
# vi /etc/hosts
```
```
kube-master 192.168.0.1
kube-node1  192.168.0.2
kube-node2  192.168.0.3
```
## ■ docker
### インストール
podmanが入っている場合はアンインストールします。(OSを最小構成でインストールすればないはず...)
```
# yum remove podman buildah
```
[公式](https://docs.docker.com/engine/install/centos/)を参考にdockerをインストールしていきます。
```
# yum install -y yum-utils
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# yum install docker-ce docker-ce-cli containerd.io
```
dockerサービスを起動します。
```
# systemctl enable --now docker
```
### 設定
cgroupドライバを systemd 管理下に変更します。  
参考: https://kubernetes.io/docs/setup/production-environment/container-runtimes/
```
# cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
```
設定を反映します。
```
# systemctl daemon-reload
# systemctl restart docker
```
## ■ k8s
以下、SELinuxが無効になっていることを仮定して進めます。
### kubeadm、kubelet、kubectlのインストール 
レポジトリ追加します。
```
# cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```
`kubelet`、`kubeadm`、`kubectl`をインストールします。
```
# yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
```
kubeletサービスを起動します。
```
# systemctl enable --now kubelet
```
### kubeletによって使用されるcgroupドライバーの設定
参考: https://kubernetes.io/ja/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
```
# vi /etc/sysconfig/kubelet
```
```
-  KUBELET_EXTRA_ARGS=
+  KUBELET_EXTRA_ARGS=--cgroup-driver=systemd
```
kubeletサービスに設定を反映させます。
```
# systemctl daemon-reload
# systemctl restart kubelet
```
## ■ クライアントとしての設定
### クラスタへの参加
Podネットワークを作成した際に出力されたコマンドを実行します。
```
# kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```
### トークンの失効時の対応
マスタ側でトークンを再発行します。  
以下はマスタでの操作です。
```
### トークンが失効していることを確認
# kubeadm token list

### トークンの再発行
# kubeadm token create

### トークンからハッシュの生成
# openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```
