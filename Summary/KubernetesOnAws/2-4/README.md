# APIアプリケーションのビルドとデプロイ
サンプルAPIアプリケーションをビルドし、コンテナイメージを作成して、作成したEKSクラスタ上で動作させます。
## 2-4-1 事前準備
APIアプリケーションは、構築したデータベースサーバに接続する3層アプリケーションです。  
作業用端末には、アプリケーションのビルドに必要な開発ツール(OpenJDK)を導入する必要があります。  
また、アプリケーションをEKSクラスタにデプロイするには、コンテナイメージを作成し、それをコンテナレジストリに登録する必要があります。
## 2-4-2 ソースコードのビルドとコンテナイメージの作成
### ■ 作業端末へ Amazon Corretto 11 を導入
以下は、CentOS Streamで実行した際のコマンドです。
```
# rpm --import https://yum.corretto.aws/corretto.key 
# curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
# yum install -y java-11-amazon-corretto-devel
```
### ■ ソースコードのビルド
サンプルアプリケーションのソースコードは[ここ](https://github.com/kazusato/k8sbook/tree/master/backend-app)からもってきてください。  
ソースコードのビルドは、Javaアプリケーション用のビルドツールであるGradleを使用する構成としています。
```
# cd k8sbook/backend-app
# ./gradlew clean build
```
このコマンドを実行すると、次の内容が実行されます。
- 依存ライブラリのダウンロード
- プログラムのコンパイル
- テストプログラムのコンパイル
- テストの実行
- プログラム実行用のアーカイブファイル(JARファイル)の作成

正常にビルドが完了すると、`BUILD SUCCESSFUL`と表示され、作業ディレクトリ配下`build/libs`以下に`backend-app-1.0.0.jar`が作成されます。
### ■ コンテナイメージの作成
次に、コンテナイメージを作成します。  
コンテナイメージの作成は、Dockerfileを作成して、docker buildコマンドでビルドします。  
Dockerfileは、[ここ](https://github.com/kazusato/k8sbook/tree/master/backend-app)から持ってきてビルドしましょう。
```
# docker build -t k8sbook/backend-app:1.0.0 --build-arg JAR_FILE=build/libs/backend-app-1.0.0.jar .
```
## 2-4-3 コンテナレジストリの準備
作成したコンテナイメージは、作業端末上にしか存在しないため、EKS上にデプロイするには、コンテナレジストリに登録する必要があります。  
AWSではECRというコンテナレジストリサービスを提供しているので、これを利用します。  
ECRを利用するときは、コンテナイメージを登録する前に、コンテナイメージごとに`リポジトリ`を作成しておく必要があります。  
以下、APIアプリケーション用にリポジトリを作成していきます。  
  
それでは、マネジメントコンソールの`コンテナ`より`Elastic Container Registry`を選択します。  
  
![Image01](./images/2-4-1.png)
  
レジストリを1つも作成していない状態でECRのページを開くと、次のような画面が表示されるので、`リポジトリの作成`より`使用方法`を押してください。  
  
![Image02](./images/2-4-2.png)
  
次のページでは、リポジトリ名に`k8sbook/backend-app`を指定して、`リポジトリの作成`を押します。  
リポジトリ名の意味は、`k8sbook`という名前空間に属する`backend-app`というコンテナイメージという意味になります。  
画面左側にあるURIは、AWSアカウントごとのECRを指すアドレスとなります。(コンテナイメージのpushやpullをする際に必要となります。)
  
![Image03](./images/2-4-3.png)
  
正常にリポジトリが作成できると、次のような完了画面が表示されます。  
  
![Image04](./images/2-4-4.png)
  
## 2-4-4 コンテナイメージのpush
作成したコンテナイメージを作成したコンテナレジストリに登録します。  
登録する前にdocker loginでECRへの認証を通す必要があります。
### ■ ECRへのログイン
ECRんいログインするための認証情報は、AWS CLIから取得できます。  
作業端末で以下のコマンドを実行してください。
```
# aws ecr get-login-password
```
ログインする際は、パスワードを直打ちするとヒストリに残るので以下のようにしましょう。
```
# docker login -u AWS -p $(aws ecr get-login-password) https://<リポジトリのURI>
```
正常にログインできると、`Login Succeeded`と表示されます。
### ■ コンテナイメージのタグ付けとpush
ECRへのログインが完了したら、コンテナイメージを格納します。
