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
```
## ■ k8sのインストール
## ■ 
