# k8s
# 構築ログ
# docker Install
公式準拠
```
# docker --version
```
```
Docker version 19.03.12, build 48a66213fe
```
# kubectl Install
```
# curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```
```
### バイナリを実行可能にする
# chmod +x ./kubectl
```
```
### バイナリをPATHの中に移動
# sudo mv ./kubectl /usr/local/bin/kubectl
```
```
### バージョン確認
# kubectl version --client
```
# minikube Install

