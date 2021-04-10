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
次に、コンテナイメージを作成します。コンテナイメージの作成は、Dockerfileを作成して、docker buildコマンドでビルドします。  
Dockerfileは、[ここ](https://github.com/kazusato/k8sbook/tree/master/backend-app)から持ってきます。
```
# docker build -t k8sbook/backend-app:1.0.0 --build-arg JAR_FILE=build/libs/backend-app-1.0.0.jar .
```
