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
|-q, --generate-request|CSR(証明書署名要求)を生成する|
|-p, --generate-privkey|公開鍵を生成する|
|--bits|公開鍵のビット数を指定する|
|-s, --generate-self-signed|自己証明書を生成する|
|-c, --generate-certificate|証明書に署名する|
|--hash|署名に使用するハッシュアルゴリズムを指定する|
|--load-privkey|読み込む公開鍵を指定する|
|--load-ca-privkey|読み込む公開鍵証明書を指定する|
|--load-ca-certificate|読み込むCA証明書を指定する|
|--template|使用するテンプレートファイルを指定する|
|--outfile|出力ファイル名を指定する|

## ■ テンプレートファイル
|オプション|説明|
|:---|:---|
|[ DN options ]|-|
|organization|組織名|
|state|都道府県|
|country|国名|
|cn|(一般に)FQDNまたはIPアドレス|
|expiration_days|証明書の有効期限|
|ca|証明書がCA証明書であるかどうか|
|[ X.503 v3 extensions ]|-|
|signing_key|データの署名に証明書を使用する|
|encryption_key|データの暗号化に証明書を使用する|
|cert_signing_key||
|crl_signing_key||
|tls_www_server||

### 例: 自己署名証明書用
```
# X.509 Certificate options

# DN options
organization = "Some Organization"
state = "Tokyo"
country = JP
cn = "client"
expiration_days = 365
ca

# X.509 v3 extensions
cert_signing_key
crl_signing_key
```

### 例: サーバ証明書用
```
# X.509 Certificate options

# DN options
organization = "Some Organization"
state = "Tokyo"
country = JP
cn = "client"
expiration_days = 365

# X.509 v3 extensions
signing_key
encryption_key
tls_www_server
```

## ■ Tips
### 秘密鍵の生成

```
# certtool --generate-privkey --outfile key.pem --rsa
```

### CSR(証明書署名要求)の生成

```
# certtool --generate-request --load-privkey key.pem --outfile request.pem
```

### 自己署名証明書の生成

```
### CA(秘密鍵)の生成
# certtool --generate-privkey --outfile ca-key.pem

### 自己署名証明書(公開鍵)の生成
# certtool --generate-self-signed --load-privkey ca-key.pem --outfile ca-cert.pem
```

### サーバ証明書の生成
CSRを使用してサーバ証明書(公開鍵)を生成する場合
```
# certtool --generate-certificate --load-request request.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --outfile cert.pem
```
秘密鍵を使用してサーバ証明書(公開鍵)を生成する場合
```
# certtool --generate-certificate --load-privkey key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --outfile cert.pem
```

## ■ Ref
- https://straypenguin.winfield-net.com/389ds4.html
- https://qiita.com/TakahikoKawasaki/items/4c35ac38c52978805c69
- https://qiita.com/sanyamarseille/items/46fc6ff5a0aca12e1946
- https://int128.hatenablog.com/entry/2015/07/27/224351
