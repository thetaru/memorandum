# デプロイメント
デプロイメントは、(大雑把に言うと)ポッドの稼働数を管理します。  
デプロイメントは単独で動作するのではなく、レプリカセットと連携してポッド数の制御を行います。
## 8.1 デプロイメントの生成と削除
デプロイメントの生成と削除の手順はポッドと同じです。  
デプロイメントを生成するマニフェストは以下の通りです。
```yaml
### FileName: deployment1.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deploy
spec:
  replicas: 3           # ポッドテンプレートからポッドを起動する数
  selector:
    matchLabels:        # コントローラとポッドを対応付けるラベルを指定
      app: web          # ポッドは、このラベルと一致する必要あり
    template:           # template以下がポッドテンプレートで、雛形となる使用記述
      metadata:
        labels:
          app: web      # ポッドのラベル、コントローラのmatchLabelsと一致させる必要あり
      spec:
        containers:     # コンテナの仕様
          - name: nginx
            image: nginx:latest
```
