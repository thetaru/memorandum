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
External-IPのARPリクエストに応答するようになる。  
送信元クライアントに送信先PodのいるノードのMACアドレスを渡して、そのノードが受け取ったパケットを内部でルーティングしているのかな?  
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
### Hubble UI
L3/L4およびL7のKubernetesクラスタのサービス依存関係グラフを自動的に検出できる。  
上記で定義したIP範囲からExternal-IPを払い出す。
```sh
kubectl patch svc hubble-ui -n kube-system -p '{"spec": {"type": "LoadBalancer"}}'
kubectl patch svc hubble-ui -n kube-system -p '{"metadata": {"annotations": {"lbipam.cilium.io/ips": "192.168.0.95"}}}'
```
Hubble UIサービスに払い出しているExternal-IPアドレスを確認する。
```sh
kubectl get svc hubble-ui -n kube-system
```
```
NAME        TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)        AGE
hubble-ui   LoadBalancer   10.105.241.102   192.168.0.95   80:32148/TCP   10h
```
