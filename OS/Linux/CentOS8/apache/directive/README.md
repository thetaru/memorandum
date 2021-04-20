# ディレクティブ
## ServerTokens
|設定値|動作説明|
|:---|:---|
|Prod|Apacheであるということを表示|
|Min|Apacheのバージョン情報を表示|
|OS|Apacheのバージョン情報とOS情報を表示|
|Full(デフォルト)|Apacheのバージョン情報、OS情報、モジュール情報を表示|

ServerTokensの内容はエラーページに表示されてしまうのでバージョン情報等は表示させないようにしましょう。
```
ServerTokens Prod
```
## Listen
Apacheのリッスンポートを指定します。  
デフォルトでは80番でリッスンします。
```
Listen 80
```
## ServerAdmin
連絡用メールアドレスの設定です。  
エラーページに遷移した際に、問い合わせ先として設定したメールアドレスが表示されます。  
使わないのでコメントしてしまいます。
```
#ServerAdmin root@localhost
```
## ServerName
Apacheサーバが自分自身のホスト名を示す時に使われるホスト名とポート番号を設定します。  
指定しない場合は、Apacheサーバ自身のIPアドレスを逆引きしてホスト名を取得します。
```
#ServerName www.example.com:80
ServerName <hostname>
```
## DocumentRoot
Apacheサーバが外部公開するコンテンツを配置するディレクトリ(ルートディレクトリ)の設定をします。  
指定がなければデフォルトのままでいいです。
```
DocumentRoot "/var/www/html"
```
## Log
デフォルトだとわかりにくいので出力先を`/var/log/httpd/error_log`へ変更します。
```
#ErrorLog "logs/error_log"
Errorlog "/var/log/httpd/error_log"
```
## LogLevel
エラーログへ記録するメッセージのレベルを指定できます。  
指定したレベル以上のメッセージがログに書き込まれます。
|設定値|動作説明|
|:---|:---|
|emerg|直ちに対処が必要|
|alert|致命的な状態|
|crit|エラー|
|warn|警告|
|notice|重要な情報|
|info|追加情報|
|debug|デバッグメッセージ|

```
LogLevel notice
```
## AddDefaultCharset
metaタグで文字コード指定しても、AddDefaultCharsetディレクティブで指定した文字コードを優先してしまいます。  
なのでAddDefaultCharsetを無効化しましょう。
```
AddDefaultCharset Off
```
レスポンスヘッダの`Content-Type`から変更内容が見て取れます。(`curl -I`などしてどうぞ)

## Header
応答ヘッダを追加することが出来ます。  
Cookieもヘッダの一種なのでHeaderディレクティブを使えば属性をつけることができます。  
以下では、Secure属性とHttpOnly属性を付与しています。
```
Header edit Set-Cookie .* $1;Secure; HttpOnly
```
