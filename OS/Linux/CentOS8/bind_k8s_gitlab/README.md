# MetalLB+BINDで内部DNSサーバ構築
MetalLBの設定から共有IPを許可する必要がある。  
ただし、これが正解というわけではない。
## ■ 前提条件
- Kubernetesクラスタが構築済みであること
- MetalLBが導入済みであること

## ■ マニフェスト例
### BIND設定ファイル
ConfigMapに設定ファイルを押し込める。  
内部DNSのため再帰問い合わせ(recursion yes)を有効にしている。  
権威DNSを構築する場合は必ず無効にすること。  
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
    acl "internal-networks" {
      192.168.137.0/24;
      192.168.138.0/24;
    };
  named.conf.options: |-
    options {
      version "";
      hostname "";
      listen-on port 53 { any; };
      listen-on-v6 { none; };
      directory "/etc/bind";
      allow-update { none; };
      allow-query-cache { none; };
      allow-transfer { localhost; };
      forwarders { 192.168.0.1; };
      dnssec-enable yes;
      dnssec-validation yes;
    };
  named.conf.controls: |-
    controls {
      inet 127.0.0.1 allow { localhost; };
    };
  named.conf.views: |-
    view "internal" {
      match-clients { localhost; internal-networks; };
      allow-query { localhost; internal-networks; };
      recursion yes;
      include "/etc/bind/named.conf.views.internal.zones";
    };
  named.conf.views.internal.zones: |-
      zone "local" IN {
        type master;
        file "/etc/bind/local.zone";
      };
      zone "137.168.192.in-addr.arpa" IN {
        type master;
        file "/etc/bind/192.168.137.rev";
      };
      zone "138.168.192.in-addr.arpa" IN {
        type master;
        file "/etc/bind/192.168.138.rev";
      };
```
### BINDゾーンファイル
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: internal-zones
data:
  local.zone: |-
    $TTL    3600
    $ORIGIN local.
    @       IN SOA dns-01.local. root.local. (
            2021053101;
            3600      ;
            900       ;
            604800    ;
            3600      ;
    )
    @       IN A dns-01.local.
    dns-01  IN A 192.168.137.1
    dns-02  IN A 192.168.137.2
    dns-03  IN A 192.168.137.3
  192.168.137.rev: |-
    $TTL    3600
    @       IN SOA dns-01.local. root.local. (
            2021053101;
            3600      ;
            900       ;
            604800    ;
            3600      ;
    )
    @       IN PTR dns-01.local.
    1       IN PTR dns-01.local.
    2       IN PTR dns-02.local.
    3       IN PTR dns-03.local.
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
