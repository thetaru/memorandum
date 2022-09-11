# Helmコマンドチートシート
## helm version
```sh
helm version
```

## helm repo

## helm search

## helm install

## helm uninstall

## helm list

## helm status

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
```
