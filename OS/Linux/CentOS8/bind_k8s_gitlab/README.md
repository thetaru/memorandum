# MetalLB+BINDで内部DNSサーバ構築
MetalLBの設定から共有IPを許可する必要がある。  
ただし、これが正解というわけではなさそう。
## ■ 前提条件
- Kubernetesクラスタが構築済みであること
- MetalLBが導入済みであること

## ■ マニフェスト例
### BIND設定ファイル
ConfigMapに設定ファイルを押し込める。 
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: named.conf
data:
  named.conf: |-
    include "/etc/bind/named.conf.acls";
    include "/etc/bind/named.conf.options";
    include "/etc/bind/named.conf.controls";
    include "/etc/bind/named.conf.views";
  named.conf.acls: |-
    acl "internal-network" {
      192.168.137.0/24;
      192.168.138.0/24;
    };
  named.conf.options: |-
    options {
      version "unknown";
      directory "/etc/bind"
      recursion no;
      allow-update { none; };
      allow-query { localhost; internal-network; };
      allow-recursion { none; };
      allow-query-cache { none; };
      allow-transfer { localhost; };
      forwarders { 192.168.0.1; };
    };
  named.conf.controls: |-
    controls {
      inet 127.0.0.1 allow { localhost; };
    };
  named.conf.views: |-
    view "internal" {
      match-clients {
        localhost;
        internal-network;
      };
      zone "." IN {
        type hint;
        file "/etc/bind/named.ca";
      };
      zone "local" IN {
        type master;
        file "/etc/bind/local.zone";
      };
      zone "137.168.192.in-addr.arpa" IN {
        type master;
        file "/etc/bind/137.168.192.rev";
      };
      zone "138.168.192.in-addr.arpa" IN {
        type master;
        file "/etc/bind/138.168.192.rev";
      };
    };
    view "external" {};
---
```
### BINDデプロイ
サービスを起こすためのマニフェスト。
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bind-deployment
  labels:
    app: bind
spec:
  replicas: 3
  selector:
    matchLabels:
      app: bind
  template:
    metadata:
      labels:
        app: bind
    spec:
      containers:
      - name: bind
        image: internetsystemsconsortium/bind9:9.17
        ports:
        - containerPort: 53
---
apiVersion: v1
kind: Service
metadata:
  name: bind-udp
  annotations:
    metallb.universe.tf/allow-shared-ip: "true"
spec:
  type: LoadBalancer
  loadBalancerIP: 192.168.137.101
  ports:
    - name: bind-udp
      port: 53
      protocol: UDP
  selector:
    app: bind
---
apiVersion: v1
kind: Service
metadata:
  name: bind-tcp
  annotations:
    metallb.universe.tf/allow-shared-ip: "true"
  labels:
    app: bind
spec:
  type: LoadBalancer
  loadBalancerIP: 192.168.137.101
  ports:
    - name: bind-tcp
      port: 53
      protocol: TCP
  selector:
    app: bind
```
