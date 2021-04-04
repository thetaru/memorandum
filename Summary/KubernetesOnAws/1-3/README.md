# Kubernetesとは
## 1-3-1 Kubernetesのコンセプト
## 1-3-2 Kubernetesの基本オブジェクト
### ■ Pod
Podは、Kubernetesの最小単位です。  
1つのPod内には、1つ以上のコンテナを稼働することができます。
### ■ ReplicaSet
ReplicaSetは、Podをいくつ起動するかを管理するオブジェクトです。
### ■ Deployment
Deploymentは、デプロイ履歴を管理します。  
本番運用でPodを起動する際は、Deploymentの単位で管理します。
### ■ Service
Serviceは、デプロイしたPodをk8sクラスタ外部へ公開するための仕組みを提供します。(代表的なものはロードバランサ)
