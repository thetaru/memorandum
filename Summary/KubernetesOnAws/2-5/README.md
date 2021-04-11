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
### ■ APIのベースURLの確認
