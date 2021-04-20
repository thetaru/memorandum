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
応答ヘッダを追加・編集を行うことが出来ます。  
Cookieもヘッダの一種なのでHeaderディレクティブを使えば属性をつけることができます。  
  
以下では、Secure属性とHttpOnly属性を付与しています。  
こうすることで、クッキーが安全に送信され、意図しない第三者やスクリプトからアクセスされないようになります。
```
Header edit Set-Cookie ^(.*)$ $1;HttpOnly;Secure
```
※ `Secure`属性がついたクッキーはHTTPSプロトコル上の暗号化されたリクエストのみサーバに送信されるため、HTTPでは送信されないことに注意しましょう。

## Timeout
以下の処理のタイムアウト値を設定します。(デフォルトは60秒です。)
- クライアントからのHTTPリクエスト受診時のTCPパケット受信待機時間
- クライアントへのHTTPレスポンス送信時のTCPパケット送信(相手からACKを受信するまでの)待機時間
- モジュール(mod_xxx)の処理待機時間

WebサーバとAPサーバが連携している場合、APサーバ側の処理が遅れるとWebサーバがHTTPレスポンスをクライアントに送信するのも遅れてしまいます。  
この場合、Timeoutの時間を短くすることで、TCPコネクションがWebサーバに滞留することを防止します。
```
Timeout 30
```
## KeepAlive
1つのTCPコネクションを使用して複数のHTTPリクエストを処理することができます。  
複数の画像ファイルやCSSファイルを同時に読み込むWebページを配信する場合は、KeepAliveを使用することで性能が向上します。  
KeepAliveに関する設定は以下のとおりです。  
#### KeepAlive
デフォルトで有効ですが、明示的に設定しましょう。

#### MaxKeepAliveRequests
TCPコネクション維持中に一度に処理できる最大リクエスト数を示す`MaxKeepAliveRequests`は、一般的に100程度を指定しておけば不足することはありません。

#### KeepAliveTimeout
TCPコネクションを維持する最長時間(秒)を示す`KeepAliveTimeout`は、TCPコネクションを維持し続ける時間を指定します。一般的に数秒程度を指定します。  
  
これらを設定することで`KeepAliveTimeout`の期間中は、1つのTCPコネクションで複数のHTTP通信が行えます。  
```
KeepAlive on
MaxKeepAliveRequests 100
KeepAliveTimeout 3
```
