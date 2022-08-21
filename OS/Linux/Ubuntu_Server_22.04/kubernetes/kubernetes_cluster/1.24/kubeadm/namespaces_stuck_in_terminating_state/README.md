# 名前空間を削除する際にTerminatingでスタックする

```sh
# 1.
kubectl proxy &
```
```
# ポート番号をひかえる
Starting to serve on 127.0.0.1:XXXX
```

```sh
# 2.
kubectl get ns/<namespace>
kubectl get ns/<namespace> -o json > temp.json
```

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

```sh
# 4.
curl -H "Content-Type: application/json" -X PUT --data-binary @temp.json http://127.0.0.1:XXXX/api/v1/namespaces/<namespace>/finalize
```

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
