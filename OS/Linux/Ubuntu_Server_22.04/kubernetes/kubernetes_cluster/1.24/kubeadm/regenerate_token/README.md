# token/discovery-token-ca-cert-hashの再生成
以下、マスターノードでコマンドを実行する。
## ■ tokenの生成
有効期限内のトークンを確認する。
```sh
kubeadm token list
```
有効なトークンがない場合、以下のコマンドでトークンを発行する。
```sh
kubeadm token create
```

## ■ discovery-token-ca-cert-hashの生成
```sh
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```
