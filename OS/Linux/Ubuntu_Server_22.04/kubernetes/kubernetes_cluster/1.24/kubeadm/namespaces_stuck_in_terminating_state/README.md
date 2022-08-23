# 名前空間を削除する際にTerminatingでスタックする
curlコマンドでKubernetes API Serverへアクセスするために、`kubectl proxy`コマンドでプロキシさせる。
```sh
kubectl proxy &
```
```
# ポート番号をひかえる
Starting to serve on 127.0.0.1:XXXX
```
名前空間のマニフェストを取得する。
```sh
# 2.
kubectl get ns/<namespace>
kubectl get ns/<namespace> -o json > temp.json
```
マニフェストを編集し、`spec-finalizers`より`kubernetes`を削除する。
```sh
# 3.
vim temp.json
```
```json
    "spec": {
        "finalizers": [
          #kubernetes
        ]
    },
```
curlコマンドを使って、プロキシ経由でKubernetes API Serverへアクセスする。
```sh
# 4.
curl -H "Content-Type: application/json" -X PUT --data-binary @temp.json http://127.0.0.1:XXXX/api/v1/namespaces/<namespace>/finalize
```
`kubectl proxy &`プロセスをキルする。
```sh
# 5.
jobs -lr
```
```
[1]+ NNNNN 実行中               kubectl proxy &
```

```sh
# 6.
kill NNNNN
```
