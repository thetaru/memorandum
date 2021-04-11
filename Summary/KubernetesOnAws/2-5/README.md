# フロントエンドアプリケーションのビルドとデプロイ
2-4でデプロイしたAPIアプリケーションに接続して使用するフロントエンドアプリケーションのビルドとデプロイを行います。
## 2-5-1 事前準備
サンプルアプリケーションのフロントエンドは、Nuxt.jsで構築されたSPAです。  
SPAをAWSで公開する場合は、S3上にコンテンツを配置し、CloudFront経由でアクセスするのが一般的です。
### ■ 作業端末へ Node.js を導入
node.jsの[公式サイト](https://github.com/nodesource/distributions)よりLTS版をインストールします。
```
# curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
```
動作確認をします。
```
# node --version
```
## 2-5-2 フロントエンドアプリケーションのビルド
作業端末で、フロントエンドアプリケーションの資材が置かれたフォルダに移動してください。
```
# cd k8sbook/frontend-app/
```
### ■ ライブラリの取得
はじめにフロントエンドアプリケーションで使用するライブラリを取得します。  
※ package.jsonに記述されているライブラリを取得します。
```
# npm install
```
※ 場合によっては、`gcc-c++`をインストールする必要があります。
### ■ APIのベースURLの確認
サンプルアプリケーションのフロントエンドでは、ビルドの際にAPIにアクセスするためのベースURLを指定し、その値をプログラムに埋め込む仕組みになっています。  
LoadBalancerの`EXTERNAL-IP`列の値を確認しましょう。
```
# kubectl get service
```
```
NAME                          TYPE           CLUSTER-IP      EXTERNAL-IP                                                                   PORT(S)          AGE
service/backend-app-service   LoadBalancer   10.100.218.65   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-XXXXXXXXX.ap-northeast-1.elb.amazonaws.com   8080:30714/TCP   31s
```
### ■ ビルドの実行
フロントエンドアプリケーションのビルドを行います。  
ビルドは以下のコマンドで実行できます。
```
# BASE_URL=http://<EXTERNAL-IPの値>:8080
# npm run build
```
