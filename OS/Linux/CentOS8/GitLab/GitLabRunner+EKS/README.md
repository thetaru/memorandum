# GitLab RunnerとAWS EKSの連携
## ■ 前提条件
- AWS EKSクラスタが構築済みであること
## ■ 構成
今回はプロジェクト全体に反映される管理者エリアから設定します。(プロジェクト単位での反映もできます。)
  
管理者エリアを開き、画面左側のKubernetesを押します。
  
![Image01](./images/01.png)  
  
初回画面は下の画像になっており、`Integrate with a cluster certificate`を押します。
  
![Image02](./images/02.png)  
  
すでに構築済みのクラスタを登録するので、`Connet existing cluster`を押します。
  
![Image03](./images/03.png)  
  
クラスタ登録に必要となる情報を入力します。  
必要な情報は以下のとおりです。
- API URL
- CA Certificate
- サービストークン
  
![Image04](./images/04.png)  
  
GitLab Runnerをインストールします。
  
![Image05](./images/05.png)  
  
https://qiita.com/ynott/items/46d4b2926afec0d788f2
