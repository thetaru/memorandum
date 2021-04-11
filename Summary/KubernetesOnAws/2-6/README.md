# バッチアプリケーションのビルドとデプロイ
スケジュール起動されるバッチアプリケーションのビルドとデプロイを行います。
## 2-6-1 事前準備
バッチアプリケーションは、APIアプリケーションと同様、JavaでSprint Bootを使用して構築されたアプリケーションです。  
アプリケーションが起動すると、環境変数で指定されたS3バケット上のファイルを取得し、ファイルの内容をデータベースに登録します。  
このときアクセスするバケットは、フロントエンドコンテンツを配置したバケットとは異なり、特定のユーザしかアクセスできない設定とします。  
  
このアプリケーションをk8sのCronJobという仕組みを用いて、定期実行させます。
## 2-6-2 バッチアプリケーションのビルドとコンテナイメージの作成
バッチアプリケーションのソースコードをビルドし、コンテナイメージを作成します。
### ■ ソースコードのビルド
バッチアプリケーションのソースコードは、[ここ](https://github.com/kazusato/k8sbook/tree/6d9d359fcf1cad348715fd2e6fe8e35cde725df7/batch-app)からもってきてください。  
バッチアプリケーションは、APIアプリケーション同様、Gradleでビルドを行います。
```
# cd k8sbook/batch-app
# ./gradlew clean build
```
正常にビルドが行われると`BUILD SUCCESSFUL`と表示され、作業フォルダ配下の`build/libs`以下に`batch-app-1.0.0.jar`ファイルが作成されます。
### ■ コンテナイメージの作成
コンテナイメージを作成します。
```
# docker build -t k8sbook/batch-app:1.0.0 --build-arg JAR-FILE~build/libs/batch-app-1.0.0.jar .
```
## 2-6-3 ECRレポジトリの作成
作成したコンテナイメージをECR上に登録するため、バッチアプリケーション用のリポジトリを作成します。  
マネジメントコンソールの`コンピューティング`から`Elastic Container Registry`を開き、`リポジトリの作成`を押してください。  
  
![Image01](./images/2-6-1.png)
  
`リポジトリ名`に`k8sbook/batch-app`と入力し、`リポジトリの作成`を押します。
  
![Image02](./images/2-6-2.png)
  
正常に作成できると、次のような画面が表示されます。
  
![Image03](./images/2-6-3.png)
  
## 2-6-4 コンテナイメージのpush
2-4-4と同様です。細かい説明は省きます。
### ■ ECRへのログイン
```
# docker login -u AWS -p $(aws ecr get-login-password) https://<リポジトリのURI>
```
### ■ コンテナイメージのタグ付けとpush
```
# docker tag k8sbook/batch-app:1.0.0 <レポジトリのURI>:1.0.0
# docker push <レポジトリのURI>:1.0.0
```
## 2-6-5 S3バケットの作成
バッチアプリケーションが利用するS3バケットを作成します。  
マネジメントコンソールからCloudFormationを開き、`スタックの作成`-`新しいリソースを使用(標準)`を押し、`テンプレートファイルのアップロード`から`40_s3_batch_cfn.yaml`を選択して`次へ`を押します。  
  
![Image04](./images/2-6-4.png)
  
`スタックの詳細を指定`画面では、スタックの名前を`eks-work-batch`と指定し、パラメータ-BuchetSuffixに任意の文字列(ここではksを使用)を入力して`次へ`を押してください。  
※ BucketSuffixは一意(他の人とかぶらないように)しなければなりません。
  
![Image05](./images/2-6-5.png)
  
`スタックオプションの設定`画面は変更は不要なので`次へ`を押して進みます。  
  
`レビュー`画面では、構成を確認して問題なければ`AWS CloudFormationによってIAMリソースがカスタム名で作成される場合があることを承認します。`にチェックを入れ、`スタックの作成`を押します。
  
![Image06](./images/2-6-6.png)
  
スタックの作成が開始されたら、マネジメントコンソールのCloudFormation画面でステータスを確認し、`CREATE_COMPLETE`になるのを待ちます。  
これでバッチアプリケーション用のS3バケットが作成されました。
### ■ 2-6-6 ConfigMapの作成
バッチアプリケーションの設定値を格納するConfigMapを作成します。  
ConfigMapは、k8sで設定値を保持するための仕組みです。  
ここでは、先ほど作成したS3バケットの名称やS3内のフォルダ名などを保持するConfigMapを登録します。  
  
ConfigMapはkubectlで設定できますが、バケット名のサフィックスを指定する必要があるので、envsubstを利用した以下のコマンドを実行してください。
```
# BUCKET_SUFFIX=<BucketSuffixの値> \
envsubst < 41_config_map_batch_k8s.yaml.template | \
kubectl apply -f -
```
## 2-6-7 S3アクセス用アクセスキーの取得とSecretの作成
バッチアプリケーションでは、S3からファイルを取得して利用します。  
バッチアプリケーションがアクセスするS3バケットは、特定の許可されたユーザからしかアクセスできない設定とするので、バッチアプリケーションにはS3にアクセスするための認証情報を渡しておく必要があります。  
  
APIアプリケーションの場合と同様に、機密情報を管理するためのk8sリソースであるSecretを使用します。
### ■ アクセスキーの取得
Secretを作成する前に、認証情報を取得します。  
`管理とガバナンス`より`Systems Manager`を押します。
  
![Image07](./images/2-6-7.png)
  
画面左側のメニューより`パラメータストア`を開きます。
  
![Image08](./images/2-6-8.png)
  
すると、`BatchUserAccessKey`と`BatchUserSecretAccessKey`の2つの値が登録されていることがわかります。  
  
![Image09](./images/2-6-9.png)
  
それぞれの`名前`欄のリンクをクリックすると、詳細情報が表示され、`値`欄に登録されている値が表示されます。
  
![Image10](./images/2-6-10.png)
  
### ■ Secretの作成
Secretを作成します。Secretはパスワードなどの機密情報を扱うときに使うリソースです。  
先ほどパラメータストアから取得したアクセスキー、シークレットアクセスキーを指定して、以下のコマンドを実行してください。
```
# AWS_ACCESSKEY=<アクセスキー> \
AWS_SECRETKEY=<シークレットアクセスキー> \
envsubst < 42_batch_secrets_k8s.yaml.template | \
kubectl apply -f -
```
```
secret/batch-secret-config created
```
## 2-6-8 入力ファイルの配置
AWS CLIを使って、バッチアプリケーションが利用する入力ファイルをバケットにアップロードしましょう。
```
# aws s3 sync ../batch-app/sample_data/normal s3://eks-work-batch-<BucketSuffixの値>/locationData --delete --include "*" --acl public-read
```
## 2-6-9 バッチアプリケーションのデプロイ
バッチプログラムを動かすための準備が完了しました。  
バッチアプリケーション実行前のデータベースの内容とS3バケットの状態を確認します。  
### ■ データベースの内容確認
データベースの内容確認は、セッションマネージャで踏み台サーバに接続して行います。  
以下、セッションマネージャから踏み台サーバにてコマンドを実行します。
```
$ psql -U mywork -h <RDSエンドポイントアドレス> myworkdb
Password for user mywork: <- myworkのパスワード(RdsUserSecretのパスワードを使用する)
```
ログイン後、PostgreSQLのプロンプトが表示されます。
```
myworkdb=> select * from location limit 58;
 location_id | location_name | region_id |                                            note
-------------+---------------+-----------+--------------------------------------------------------------------------------------------
           1 | 美ら海水族館  |         9 | 沖縄の代表的な水族館で、ジンベエザメをはじめ、様々な沖縄の海の生き物を見ることができます。
           2 | 首里城        |         9 | 琉球王朝の王城で、世界遺産の1つです。
(2 rows)
```
### ■ S3バケットの状態確認
S3バケットの状態確認をします。  
マネジメントコンソールより`ストレージ`から`S3`を選択してください。  
  
![Image11](./images/2-6-11.png)
  
すると、バケットの一覧が表示されるので、`eks-work-batch-`からはじまるバケットのバケット名をクリックします。
  
![Image12](./images/2-6-12.png)
  
バケット名をクリックすると、`locationData`フォルダが表示されます。  
  
![Image13](./images/2-6-13.png)
  
ここでlocationDataフォルダのフォルダ名をクリックすると、`sample_location1.csv`,`sample_location2.csv`の2ファイルが表示されます。  
  
![Image14](./images/2-6-14.png)
  
### ■ バッチアプリケーションのデプロイ
バッチアプリケーションをデプロイします。  
バッチアプリケーションは、CronJobというk8sのリソースを用いて、5分ごとに起動するようにします。  
以下のコマンドを実行してください。
```
# ECR_HOST=<リポジトリのURIからリポジトリ名を除く> \
envsubst < 43_cronjob_k8s.yaml.template | \
kubectl apply -f -
```
ここでk8s上に作成されているリソースを確認しましょう。  
以下のコマンドを実行してください。
```
# kubectl get cronjob
```
```
NAME        SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
batch-app   */5 * * * *   False     0        <none>          15s
```
一方、ポッドの状態を見ると、以下のとおりAPIアプリケーションのポッドのみが表示されています。
```
# kubectl get pod
```
