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
# certtool --generate-privkey --outfile key.pem --rsa
```

### CSR(証明書署名要求)の生成
証明書署名要求は、CA(認証局)にサーバの公開鍵に署名してもらうよう要求するメッセージです。
```
# certtool --generate-request --load-privkey key.pem --outfile request.pem
```

### 自己署名証明書の生成

```
# certtool --generate-privkey --outfile ca-key.pem
# certtool --generate-self-signed --load-privkey ca-key.pem --outfile ca-cert.pem
```

### サーバ証明書の生成
CSRを使用して証明書を生成する場合
```
# certtool --generate-certificate --load-request request.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --outfile cert.pem
```
秘密鍵を使用して証明書を生成する場合
```
# certtool --generate-certificate --load-privkey key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --outfile cert.pem
```
