# bind+k8s+gitlabでDNSサーバを構築する
https://heartbeats.jp/hbblog/2020/02/octodns01.html
## ■ 前提条件
- Kubernetesクラスタが構築済みであること
- MetalLBが導入済みであること

## ■ 構成
gitlabでzoneファイルをyaml形式で管理し、更新時に逆変換してbindコンテナのディレクトリに投げつける。  
更新もrndcでやる(スクリプトに組み込む)ためリアルタイムに更新がかかる。

## ■ BINDコンテナのマニフェスト
```yaml
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
