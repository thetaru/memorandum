# Helmコマンドチートシート
## helm version
```sh
helm version
```

## helm search

## helm install

## helm uninstall

## helm repo
```sh
# Usage
helm repo [command]
```
```sh
# リポジトリの一覧を表示する
helm repo list
```

## helm search
```sh
# Usage
helm search repo [CHART]
```
```sh
# チャートの一覧を表示する
helm search repo grafana
```

## helm list
```sh
# リリース名をみる
helm list [-n <namespace>]
```

## helm status

## helm pull
```sh
helm pull grafana/loki-distributed --untar
```

## helm show
```sh
# Usage
 helm show values [CHART] [flags]
```
```sh
# Example: values.yamlファイルを抽出する
helm show values prometheus-community/kube-prometheus-stack > values.yaml
```

## helm template
```sh
# Usage
helm template [NAME] [CHART] [flags]
```
```sh
# Example: マニフェストを抽出する
helm template kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring > kube-prometheus-stack.yaml

# Example: values.yamlを適用してマニフェストを抽出する
helm template kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring -f values.yaml > kube-prometheus-stack.yaml
```

# インストール時によくある流れ
```sh
# common
helm install [NAME] [CHART] [flags]
helm repo update
helm repo list
helm search repo [keyword] [flags]

# optional
helm show values [CHART] [flags]  > values.yaml
helm template [NAME] [CHART] [flags] > template.yaml
```
