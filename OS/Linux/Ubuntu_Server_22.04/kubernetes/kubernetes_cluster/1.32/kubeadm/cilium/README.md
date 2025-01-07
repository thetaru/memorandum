# Cilium
## LoadBalancer IP Address Management(LB IPAM)
Ciliumが`LoadBalancer`タイプのサービスにIPアドレス(VIP)を割り当てることができる。(MetalLBのデプロイが不要)
### Pool
LB IPAMでは、IPプールを作成しIP割り当て範囲を定義できる。(定義方法はいくつかあるので詳しくはドキュメントを参照)
```yaml
apiVersion: "cilium.io/v2alpha1"
kind: CiliumLoadBalancerIPPool
metadata:
  name: default
  namespace: kube-system
spec:
  blocks:
  - start: "192.168.0.90"
    stop: "192.168.0.99"
```
CiliumLoadBalancerIPPoolの確認は以下のコマンドで行う。
```sh
kubectl get ippools
```
```
NAME      DISABLED   CONFLICTING   IPS AVAILABLE   AGE
default   false      False         10              10h
```
### L2 Announcements
External-IPのARPに応答する。(送信先PodのいるノードのMACアドレスを渡して、そのノードが受け取ったパケットを内部でいいかんじにルーティングしているのかな)  
こういう仕様なので、特定のExternal-IPに応答できるのは、クラスタ内の1ノードのみとなる。  

CiliumL2AnnouncementPolicyを定義し、L2ネットワーク上でどのノードがどのサービスをアナウンスするかを制御する。  
下記の例は、サービス(serviceSelector)は指定せず、ノード(nodeSelector)とインターフェース(interfaces)を指定している。
```yaml
apiVersion: "cilium.io/v2alpha1"
kind: CiliumL2AnnouncementPolicy
metadata:
  name: default
  namespace: kube-system
spec:
  nodeSelector:
    matchExpressions:
    - key: node-role.kubernetes.io/control-plane
      operator: DoesNotExist
  interfaces:
  - ^ens[0-9]+
  externalIPs: true
  loadBalancerIPs: true
```
CiliumL2AnnouncementPolicyの確認は以下のコマンドで行う。
```sh
kubectl get ciliuml2announcementpolicies
```
```
NAME      AGE
default   10h
```