# ArgoCD
## adminパスワードの永続性について
adminのパスワードは`argocd-secret`Secretにbcryptハッシュとして保存されるので、永続化はされている。  
一般ユーザについては調べてない...
```sh
kubectl get secret -n argocd argocd-secret
```
```
NAME            TYPE     DATA   AGE
argocd-secret   Opaque   5      12h
```
