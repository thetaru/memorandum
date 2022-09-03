# MetalLB
## ■ Installation
### Manifest
```sh
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.5/config/manifests/metallb-native.yaml
```
### Kustomize
### Helm

## ■ Configuration
### Defining The IPs To Assign To The Load Balancer Services
サービスに割り当てるIPアドレス(IPAddressPool)を定義する。  
また、IPAddressPoolは複数宣言することができる。
```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.10.0/24
  - 192.168.9.1-192.168.9.5
  - fc00:f853:0ccd:e799::/124
```
### L2Configuration
IPAddressPoolで定義したIPアドレスをL2Advirtisementと紐付ける。  
下記のyamlでは、ipAddressPoolsにIPAddressPool`first-pool`を割り当てている。
```yaml
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
```
