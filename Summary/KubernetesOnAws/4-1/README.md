# モニタリング、監視
## ■ 4-1-1 クラスタの状況を把握する
特になし
## ■ 4-1-2 CloudWatch Container Insights で アプリケーション(Pod)の状況を把握する
CloudWatch Container Insightsを使って、クラスタのNode、Pod、Namespace、Serviceレベルのメトリクスを参照できます。  
CloudWatchエージェントをDaemonSetとして起動して、必要なメトリクスをCloudWatchに転送する仕組みになっています。  
※ DeaemonSetとして起動するので各ノードに1つずるPodが配置されます。  
### データノードのIAMロールにポリシーを追加する
CloudWatch Container Insightsを使うには、データノードにアタッチしているIAMロールに、IAMポリシーをアタッチします。
1. マネジメントコンソールからEC2のページを開く
2. クラスタのデータノードの１つを選択し、詳細画面に表示されるIAMロールをクリックします。
3. IAMロールのページが開くので、`ポリシーをアタッチします`を選択します。
4. IAMポリシー一覧から`CloudWatchAgentServerPolicy`を選択し、`ポリシーのアタッチ`を選択します。

### CloudWatch用のNamespaceを作成する
EKSクラスタにCloudWatch用のNamespaceを作成します。
```
# kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml
```

### CloudWatch用のService Accountを作成する
CloudWatchエージェントのPodが使うService Accountを作成します。
```
# kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-serviceaccount.yaml
```

### CloudWatchエージェントが使用するConfigMapを作成する
CloudWatchエージェントのPodは、ConfigMapを使って各種設定を読み込むので、このConfigMapを作成しておきます。  
まず、ConfigMap作成用のマニフェストをダウンロードします。
```
# curl -O https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-configmap.yaml
```
ダウンロードしたマニフェスト内に、クラスタ名を設定する箇所があるので編集します。
```
# vi cwagent-configmap.yaml
```
```
-  "cluster_name": "{{cluster_name}}",
+  "cluster_name": "eks-work-cluster",
```
編集後、マニフェストを適用してConfigMapを作成します。
```
# kubectl apply -f cwagent-configmap.yaml
```

### CloudWatchエージェントをDaemonSetとして起動する
CloudWatchエージェントを起動します。
```
# kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-daemonset.yaml
```
以上で、CloudWatch Container Insightsの設定は完了です。  
正しく設定されていれば、マネジメントコンソールのCloudWatch Logsにロググループ(`/aws/containerinsights/eks-work-cluster/performance`)が作成されているはずです。

## ■ 4-1-3 CloudWatchアラームによる通知を行う
閾値を設けて通知できるようにする。(アラームのところから設定可能)

## ■ 4-1-4 リソースの削除
```
# kubectl delete -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-daemonset.yaml
```
```
# kubectl delete -f cwagent-configmap.yaml
```
```
# kubectl delete -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-serviceaccount.yaml
```
```
# kubectl delete -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml
```
