# MetalLB
## ■ 手順
```
# kubectl edit configmap -n kube-system kube-proxy
```
```
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true
```
