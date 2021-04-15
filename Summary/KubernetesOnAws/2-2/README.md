# EKSクラスタ構築
## 2-2-1 ベースリソースの構築
### ■ 利用ツールの導入
以下の手順を実行するには、次のツールを作業端末に導入しておく必要があります。
- AWS CLI
- eskctl
- kubectl
- Git

### ■ 構築情報
#### 仮想環境のセットアップ
```
### Python仮想環境管理用ディレクトリを作成
# mkdir -p /opt/python/venv
# cd /opt/python/venv

### 仮想環境作成
# python3 -m venv aws_eks

### 仮想環境をアクティベート(以後抜けない限り 仮想環境のPythonが実行される)
# source aws_eks/bin/activate
```
#### AWS CLIの導入
```
### パッケージのダウンロードと解凍
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
# unzip /tmp/awscliv2.zip

### インストーラの実行
# sudo ./aws/install

### 不要なディレクトリを削除
# rm -rf aws
```
#### eksctlの導入
```
# curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
# sudo mv /tmp/eksctl /usr/local/bin
```
#### kubectlの導入
AWSで配布しているkubectlパッケージを使用します。[ここ](https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/install-kubectl.html)を参照してください。
```
# curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
# chmod +x ./kubectl
# mkdir -p $HOME/bin && mv ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
# echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
# kubectl version --short --client
```
### ■ ベースリソースの作成手順
CloudFormationを用いてVPCなどのベースリソースの作成を行います。  
マネジメントコンソールでCloudFormationのページに移動しましょう。  
  
![Image01](./images/2-2-1.png)
  
CloudFormationのページを開くと、次のような画面が表示されます。
  
![Image02](./images/2-2-2.png)
  
`スタックの作成` - `新しいリソースを使用`を押して、ベースリソース作成のテンプレート選択画面に移動します。
※ スタックとは、CloudFormationで作成する一連のリソースを指します。  
  
![Image03](./images/2-2-3.png)
  
`前提条件-テンプレートの準備`にある`テンプレートの準備完了`を選択します。  
次に`テンプレートの指定`で`テンプレートファイルのアップロード`を選択して、`ファイルの選択`を押します。  
[ここ](https://github.com/kazusato/k8sbook/tree/master/eks-env)から取得したテンプレートファイル(01_base_resources_cfn.yaml)を選択してください。  
選択後、`次へ`を押します。
  
![Image04](./images/2-2-4.png)
  
`スタックの名前`に`eks-work-base`と入力してください。  
パラメータはこのテンプレートで使用するパラメータが表示されていますが、いずれも初期値のままで問題ないです。  
スタックの名前を指定したら、`次へ`を押します。
  
![Image05](./images/2-2-5.png)
  
`スタックオプションの設定`は設定を変更する必要がないので、そのまま`次へ`を押します。
  
![Image06](./images/2-2-6.png)
  
`レビュー`画面が表示されます。パラメータは変更してないので`テンプレートURL`に表示されているファイル名が正しいか確認して、問題なければ`スタックの作成`を押してください。
  
![Image07](./images/2-2-7.png)
  
スタックの作成がはじまると、最初の画面に戻り、作成状況が表示されます。  
`eks-work-base`スタックが`CREATE_IN_PROGRESS`状態になっていることがわかります。
  
![Image08](./images/2-2-8.png)
  
しばらくすると、状態が`CREATE_COMPLETE`に変わります。  
自動的に更新されない場合は、更新ボタンを押してください。
### ■ 作成されたリソースの確認
作成されたリソースを確認しておきましょう。  
`サービス`-`ネットワーキングとコンテンツ配信`より`VPC`を選択してください。
  
![Image09](./images/2-2-9.png)
  
次に、画面左側のメニューから`VPC`を選びます。
  
![Image10](./images/2-2-10.png)
  
ここの`NAME`欄に`eks-work-VPC`のエントリーが表示されていれば、正しくリソースが作成されています。
  
![Image11](./images/2-2-11.png)
  
## 2-2-2 EKSクラスタの構築
次に、EKSクラスタをeksctlコマンドで構築します。
### ■ ベースリソースの情報取得
EKSクラスタ構築に先立ち、先ほど作成したベースリソースの情報を取得する必要があります。  
この情報は、CloudFormationのスタック詳細情報として取得できます。
リソースの作成後、マネジメントコンソールでスタック詳細情報を開くと、`出力`タブに、後続の作業で必要となる情報が表示されます。
  
![Image12](./images/2-2-12.png)
  
CloudFormation画面で`eks-work-base`スタックを選択し、画面右側の`出力`タブを押します。  
ここでは、`WorkerSubnets`の値を使用するので、値の部分をコピーしておいてください。
### ■ eksctlの実行
eksctlコマンドは、オプションとして各種パラメータを指定すると、様々な構成のEKSクラスタを構築することができます。  
コンソールを開き、以下のコマンドを実行してください。
```
# eksctl create cluster \
--vpc-public-subnets <WorkerSubnetsの値> \
--name eks-work-cluster \
--region ap-northeast-1 \
--version 1.19 \
--nodegroup-name eks-work-nodegroup \
--node-type t2.small \
--nodes 2 \
--nodes-min 2 \
--nodes-max 5
```
環境構築には約20分ほどかかります。
### ■ CloudFormationでの進捗状況の確認
eksctlコマンドはは内部でCloudFormationを使ってEKSクラスタやワーカーノードを構築しています。  
コマンド実行後、CloudFormation画面を見ると、作成されたスタックの内容や、その進捗状況を確認できます。  
  
![Image13](./images/2-2-13.png)
  
2つのスタックが作成されていることがわかります。  
このように、eksctlでは、
- eksクラスタ構築
- ワーカーノード構築

の2つのCloudFormationスタックを作成してEKS環境を構築しています。
### ■ kubeconfigの設定
eksctlは、EKSクラスタ構築の中で、kubeconfigファイルを自動的に更新してくれます。  
kubeconfigファイルは、k8sクライアントであるkubectlが利用する設定ファイルで、接続先のk8sクラスタの接続情報(コントロールプレーンのURL、認証情報、k8sの名前空間など)を保持します。  
  
以下のコマンドを実行し、新しい設定(コンテキスト)が作成されることを確認します。
```
# kubectl config get-contexts
```
```
CURRENT   NAME                                                    CLUSTER                                     AUTHINFO                                                NAMESPACE
*         k8seksadmin@eks-work-cluster.ap-northeast-1.eksctl.io   eks-work-cluster.ap-northeast-1.eksctl.io   k8seksadmin@eks-work-cluster.ap-northeast-1.eksctl.io   
```
kubectlからEKSクラスタに接続できるようになったことを確認します。
```
# kubectl get node
```
```
NAME                                               STATUS   ROLES    AGE   VERSION
ip-192-168-0-171.ap-northeast-1.compute.internal   Ready    <none>   12m   v1.19.6-eks-49a6c0
ip-192-168-2-230.ap-northeast-1.compute.internal   Ready    <none>   12m   v1.19.6-eks-49a6c0
```
## 2-2-3 EKSクラスタの動作確認
EKSクラスタの構築が完了しました。構築したクラスタが動作するか確認しましょう。  
以下のコマンドを実行してください。YAMLファイルは[ここ](https://github.com/kazusato/k8sbook/tree/master/eks-env)から取得してください。  
このマニフェストを適用するとポッドが生成されます。
```
# kubectl apply -f 02_nginx_k8s.yaml
```
次に、生成されたポッドを確認します。
```
# kubectl get pod
```
```
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          2m25s
```
k8sクラスタに対するポートフォワードを行います。
```
# kubectl port-forward nginx-pod 8080:80
```
```
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```
別ターミナルを開いて`http://localhost:8080`にアクセスしてみましょう。
```
# curl http://localhost:8080
```
```
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<以下省略>
```
このポッドは今後使用しないので削除します。
```
# kubectl delete -f 02_nginx_k8s.yaml
```
以上で、構築したEKSクラスタが正しく動作していることが確認できました。  
