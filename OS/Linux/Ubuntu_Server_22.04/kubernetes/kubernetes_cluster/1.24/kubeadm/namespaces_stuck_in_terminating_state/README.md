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
kubectl get ns/<namespace>
kubectl get ns/<namespace> -o json > temp.json
```
マニフェストを編集し、`spec-finalizers`より`kubernetes`を削除する。
```sh
vim temp.json
```
```json
    "spec": {
        "finalizers": [
        ]
    },
```
curlコマンドを使って、プロキシ経由でKubernetes API Serverへアクセスする。
```sh
curl -H "Content-Type: application/json" -X PUT --data-binary @temp.json http://127.0.0.1:XXXX/api/v1/namespaces/<namespace>/finalize
```
`kubectl proxy`プロセスをキルする。
```sh
jobs -lr
```
```
[1]+ NNNNN 実行中               kubectl proxy &
```

```sh
kill NNNNN
```
