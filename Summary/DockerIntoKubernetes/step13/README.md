# イングレス
イングレスは、k8sクラスタの外部からのリクエストをk8sクラスタ内部のアプリケーションへつなぐためのAPIオブジェクトです。  
デプロイメントの管理下で起動されたポッドのアプリケーションを外部公開用のURLとマッピングして、インターネットへ公開することができます。
## 13.1 イングレスの機能概要
イングレスの代表機能は以下の通りです。
- 公開用URLとアプリケーションの対応付け
- 複数のドメイン名を持つ仮想ホストの機能
- クライアントのリクエストを複数のポッドへ負荷分散
- SSL/TLS暗号化通信(HTTPS)
- セッションアフィニティ

これか機能により、ロードバランサやリバースプロキシの替わりになります。  
イングレスを利用するには、k8sクラスタにイングレスコントローラがセットアップされている必要があります。  
注意点としては、イングレスコントローラの実装によっては、インターネットの公開用IPアドレスを取得する機能は必ずしも含まれません。
## 13.2 イングレスの学習環境準備
minikube使ってないので飛ばし(?)
## 13.3 公開用URLとアプリケーションの対応付け
公開用URLのパス部分に、複数アプリケーションを対応付けることができます。  
以下は`reservation`と`order`に対してそれぞれ専用アプリケーションを対応させています。
- http://abc.sample.com/reservation    # 予約アプリケーションのポッドへ転送
- http://abc.sample.com/order          # 注文アプリケーションのポッドへ転送

つまりイングレスは、公開用URLのパスに対するリクエストをポッドを代表するサービスへ振り分けます。  
サービスとドメイン名が対応する感じ。

### 仮想ホストとサービスを関係付けるマニフェスト記述
イングレスのマニフェストを見ていきます。  
イングレスのマニフェストでは、メタデータのアノテーションが重要な役割をもちます。  
アノテーションを記述して、イングレスコントローラへコマンドを送ります。  
#### アノテーションの例
- kubernetes.io/ingress.class: 'nginx': 複数のイングレスコントローラがk8sクラスタ内で動作している場合、指示の送り先となるイングレスコントローラを指定できます。
- nginx.ingress.kubernetes.io/rewrite-target: /: URLパスを書き換える要求です。この設定がないと、クライアントからのリクエストのパスをポッドへそのまま転送してFile Not Foundとなります。

実際のマニフェストの例です。
```yaml
### FileName: ingress.yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: hello-ingress
  annotations:
    kubernetes.io/ingress.class: 'nginx'
    nginx.ingress.kubernetes.io/rewrite-target: /
  spec:
    rules:
      - host: abc.sample.com                          # ドメイン名1
        http:
          paths:
            - path: /                                 # URLのパス1
              backend:                                # URLパス部分とサービス対応
                serviceName: helloworld-svc
                servicePort: 8080
            - path: /apl2                             # URLのパス2
              backend:                                # URLパス部分とサービス対応
                serviceName: nginx-svc
                servicePort: 9080
      - host: xyz.sample.com                          # ドメイン名2
        http:
          paths:
            - path: /                                 # URLのパス3
              backend:
                serviceName: java-svc
                servicePort: 9080
```
