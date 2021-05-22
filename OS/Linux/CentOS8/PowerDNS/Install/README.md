# PowerDNS(Authoritative Server)のインストール
2021/5/22時点でPowerDNS公式ページにはCentOS8(およびStream)についてのインストール方法が確認できなかったためコンテナを使用します。  
以下、k8sを構築してサービスを提供します。
## ■ k8sの構築
podmanが入っているならアンインストールします。
```
# yum remove podman
```
k8sの
