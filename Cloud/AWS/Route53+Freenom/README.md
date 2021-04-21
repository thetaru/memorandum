# Route53 + Freenom(無料ドメイン)連携方法
https://dev.classmethod.jp/articles/mesoko-r53-cdn/  
Freenomで取得したドメインをRoute53に委任します。
## ■ Route53 - ホストゾーン作成
  
![image01](./images/01.png)
  
![image02](./images/01.png)
  
![image03](./images/01.png)
    
![image04](./images/01.png)
    
## ■ Freenom - ドメイン取得
## ■ [Option] S3
外部公開サービスのURLと取得したドメインを紐付けたいだけですが、ここではS3を使用することにしました。
## ■ Route53 - DNSレコード登録
