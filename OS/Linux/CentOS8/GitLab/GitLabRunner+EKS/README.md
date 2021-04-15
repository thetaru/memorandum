# GitLab RunnerとEKSの連携
`AWS CLI`,`AWS CDK`の設定や`EKSクラスタ`の構築がされていることを前提とします。
## ■ EKS連携のための情報取得
以下の情報をEKSクラスタから取得します。
- シークレット名
- トークン
- CA Certificate

シークレット名を取得します。この値は後続のコマンドで必要になります。
```
# kubectl get secrets
```
```
NAME                  TYPE                                  DATA   AGE
default-token-79tsx   kubernetes.io/service-account-token   3      13m
```
取得したシークレット名を入れて実行します。
```
# kubectl get secret default-token-79tsx -o jsonpath="{['data']['token']}" | base64
```
同様に、取得したシークレット名を入れて実行します。
```
# kubectl get secret default-token-79tsx -o jsonpath="{['data']['ca\.crt']}" | base64
```
## ■ GitLabプロジェクトとEKSクラスタを連携
