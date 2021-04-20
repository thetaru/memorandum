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
