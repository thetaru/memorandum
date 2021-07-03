# certtool
## ■ インストール
```
# yum install gnutls-utils
```

## ■ シンタックス
```
certtool [オプション]
```

## ■ 便利なオプション
|オプション|説明|
|:---|:---|
|-q, --generate-request||
|-p, --generate-privkey|公開鍵を生成する|
|--bits|公開鍵のビット数を指定する|
|-s, --generate-self-signed|自己証明書を生成する|
|-c, --generate-certificate|証明書に署名する|
|--hash|署名に使用するハッシュアルゴリズムを指定する|
|--load-privkey|読み込む公開鍵を指定する|
|--load-ca-privkey|読み込む公開鍵証明書を指定する|
|--load-ca-certificate||
|--template|使用するテンプレートファイルを指定する|
|--outfile|出力ファイル名を指定する|

## ■ テンプレートファイル
|オプション|説明|
|:---|:---|
|[DN options]|-|
|organization||
|state||
|country||
|cn||
|expiration_days||
|[X.503 v3 extensions]|-|
|signing_key||
|encryption_key||
|tls_www_server||

## ■ Tips
### 秘密鍵の生成

```
# certtool --generate-privkey --bits 4096 --rsa --outfile "key.pem"
```

### CSRの生成

```
# certtool --generate-request --hash SHA512 --load-privkey "key.pem" --template "template" --outfile "request.pem"
```

### 自己署名証明書の生成

```
# certtool --generate-self-signed --hash SHA512 --load-ca-privkey "ca-key.pem" --load-ca-certificate "ca-crt.pem" --load-request "request.pem" --outfile "cert.pem"
```

### 証明書の生成
CSRを使用して証明書を生成する場合
```
# certtool --generate-certificate --hash SHA512 --load-privkey "key.pem" --template "template" --outfile "ca-cert.pem"
```
秘密鍵を使用して証明書を生成する場合
```
# certtool --generate-certificate --hash SHA512 --load-privkey "key.pem" --template "template" --load-ca-certificate ca-cert.pem --load-ca-privkey "ca-key.pem"  --outfile "ca-cert.pem"
```
