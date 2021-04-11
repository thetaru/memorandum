# サンプルアプリケーション環境の破棄
## 2-7-1 リソース破棄の流れ
リソース破棄の流れは、基本的に構築の逆です。  
ただしk8s上のリソースはまとめて最初に削除することにします。
## 2-7-2 リソース破棄の手順
### ■ Kubernetes上のアプリケーションとServiceを削除する
Kubernetes上にデプロイしたアプリケーション(APIとバッチ)とService(もろもろ)を削除します。  
  
まずはServiceから削除します。
```
# kubectl delete service backend-app-service
```
次に、APIアプリケーションの削除です。
```
# kubectl delete deployment backend-app
```
最後に、バッチアプリケーションの削除です。
```
# kubectl delete cronjob batch-app
```
リソースを表示してみます。
```
# kubectl get all
```
```
No resources found in eks-work namespace.
```
これでk8s上のリソースの削除は完了です。
### ■ EKSクラスタの削除
k8s上にデプロイしたあプリケーションとServiceを削除したので、EKSクラスタを削除します。  
EKSクラスタの削除は、eksctlを使って行います。
```
# eksctl delete cluster --name eks-work-cluster
```
※ EKSクラスタの削除中にベースリソースの削除はできないことに注意しましょう。
### ■ バッチアプリケーション用S3バケットを空にする
バッチアプリケーション用S3バケットの中身を空にします。  
S3バケットは、S3バケットが空の状態でCloudFormationスタックを削除することで行います。  
  
バケットを空にする処理はAWS CLIで行います。
```
# aws s3 rm s3://eks-work-batch-<BucketSuffixの値> --recursive
```
### ■ フロントエンドアプリケーション用S3バケットを空にする
同様に、フロントエンドアプリケーション用S3バケットの中身を空にします。  
```
# aws s3 rm s3://eks-work-frontend-<BucketSuffixの値> --recursive
```
### ■ バッチアプリケーション用S3バケットを削除する
AWS CLIからCloudFormationスタックを削除します。(`aws cloudformation list-stacks`でスタック名を確認できます。)
```
# aws cloudformation delete-stack --stack-name eks-work-batch
```
### ■ フロントエンドアプリケーション用S3バケットとCloudFrontディストリビューションを削除する
AWS CLIからCloudFormationスタックを削除します。(`aws cloudformation list-stacks`でスタック名を確認できます。)
```
# aws cloudformation delete-stack --stack-name eks-work-frontend
```
### ■ データベースと踏み台サーバを削除する
AWS CLIからCloudFormationスタックを削除します。(`aws cloudformation list-stacks`でスタック名を確認できます。)
```
# aws cloudformation delete-stack --stack-name eks-work-rds
```
### ■ ベースリソースを削除する
AWS CLIからCloudFormationスタックを削除します。(`aws cloudformation list-stacks`でスタック名を確認できます。)
```
# aws cloudformation delete-stack --stack-name eks-work-base
```
