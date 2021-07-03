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
|--hash|署名に使用するハッシュアルゴリズムを指定する|
|--load-privkey|読み込む公開鍵を指定する|
|--load-ca-privkey|読み込む公開鍵証明書を指定する|
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
### 公開鍵を生成する
|オプション|説明|
|:---|:---|
|ビット数|4096|
|出力先|/tmp/priv.key|

```
# certtool -p --bits 4096 --outfile /tmp/priv.key
```

### CSR(証明書の署名リクエスト)を生成する
```
# certtool -q --hash SHA512 --load-privkey "/tmp/priv.key" --template "$template_file" --outfile "/tmp/test.csr"
```

### 自己証明書を生成する
```
# certtool -s --hash SHA512 --load-privkey "$key_file" --template "$template_file" --outfile "$crt_file"
```
