# k8sで管理する内部DNSサーバ構築
corednsとk8sを利用して小規模DNSサーバとして運用してみます。  
ここではマニフェスト(corednsサービス用とcorefile用)だけを載せます。
## マニフェスト例
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coredns-deployment
  labels:
    app: coredns
spec:
  replicas: 3
  selector:
    matchLabels:
      app: coredns
  template:
    metadata:
      labels:
        app: coredns
    spec:
      containers:
      - name: coredns
        image: coredns/coredns
        command: ["/coredns", "-conf", "/etc/coredns/Corefile"]
        ports:
        - containerPort: 53
        volumeMounts:
        - name: corefile-config
          mountPath: /etc/coredns
      volumes:
      - name: corefile-config
        configMap:
          name: corefile
---
apiVersion: v1
kind: Service
metadata:
  name: coredns-service
spec:
  type: LoadBalancer
  loadBalancerIP: 192.168.137.101
  ports:
    - name: coredns-port
      port: 53
      protocol: UDP
  selector:
    app: coredns
```
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: corefile
data:
  Corefile: |
    local:53 {
      hosts {
        192.168.137.1 dns-01.local
        192.168.137.2 dns-02.local
        192.168.137.3 dns-03.local
      }
    }

    .:53 {
      forward . 8.8.8.8
    }
```
