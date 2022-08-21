# 名前空間を削除する際にTerminatingでスタックする
rook-cephを例に実施する。

```sh
kubectl proxy &
```
```
# ポート番号をひかえる
Starting to serve on 127.0.0.1:XXXX
```

```sh
kubectl get ns/<namespace>
kubectl get ns/<namespace> -o json > temp.json
```

```sh
vim temp.json
```
```json
    "spec": {
        "finalizers": [
          #kubernetes
        ]
    },
```

```sh
curl -H "Content-Type: application/json" -X PUT --data-binary @temp.json http://127.0.0.1:XXXX/api/v1/namespaces/<namespace>/finalize
```
