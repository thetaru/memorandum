# Route53 + Freenom(無料ドメイン)連携方法
https://dev.classmethod.jp/articles/mesoko-r53-cdn/  
Freenomで取得したドメインをRoute53に委任します。
|項目|値|
|:---|:---|
|取得ドメイン名|mc-thetaru-server.tk|

## ■ Route53 - ホストゾーン作成
マネジメントコンソールから`ネットワーキングとコンテンツ配信`より`Route 53`を選択し、画面左側のホストゾーンを押します。
  
![image01](./images/01.png)
  
`ホストゾーンの作成`を押します。
  
![image02](./images/02.png)
  
`ドメイン名`を入力し、タイプを`パブリックホストゾーン`に変更します。
  
![image03](./images/03.png)
   
 ホストゾーンが正常に作成されていることを確認します。  
 NSレコードが作成されていることがわかります。(委任していることがわかる)
   
![image04](./images/04.png)
    
## ■ Freenom - ドメイン取得
## ■ [Option] S3
外部公開サービスのURLと取得したドメインを紐付けたいだけですが、ここではS3を使用することにしました。
## ■ Route53 - DNSレコード登録
