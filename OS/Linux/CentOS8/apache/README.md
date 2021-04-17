# apache
|パッケージ|バージョン|
|:---|:---|
|apache|2.4|

## ■ ディレクティブ
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
## AccessLog
ログフォーマットを変更できます。  
デフォルトだとわかりにくいので出力先を`/var/log/httpd/access_log`へ変更します。
```
LogFormat "%h %l %u %t \"%r\" %t %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
CustomLog "/var/log/httpd/access_log" combined
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

## DirectoryIndex
ディレクトリにファイル指定無しのアクセスがあった場合に、どのファイルを表示するかを設定します。  
例えば、`http://192.168.137.1/`はファイルを指定していませんが、この設定を入れてアクセスするとindex.htmlが表示されます。
```
DirectoryIndex index.html
```
## AddType
MIMEタイプを設定します。  
html形式のファイル内でPHPの実行を有効にする場合は設定します。  
※ mime_moduleのロードが必要
```
AddType application/x-httpd-php .php
```
## ■ セクション
## Directory
指定したディレクトリ配下に対してアクセス制限などを個別に細かく設定できる。  
Document Rootを変更した場合は、そのDocument Rootに対するDirectory設定を忘れないようにします。
```
<Directory "/var/www/htdocs">

</Directory
```
### Options
#### Indexs
ディレクトリリスティング(ブラウザからディレクトリ情報が筒抜けになる)を無効化します。
#### FollowSymLinks
シンボリックリンク先をApacheが見れるようになります。
#### CGI
CGIを実行しない場合は許可しないようにします。
```
<IfModule alias_module>
    #ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>

#<Directory "/var/www/cgi-bin">
#    AllowOverride None
#    Options None
#    Require all granted
#</Directory>
```
## ■ 仮想ホストの設定
## ■ セキュリティ
- [ ] [セキュリティ設定](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/apache/security)
- [ ] [HTTPS対応](https://github.com/thetaru/memorandum/tree/master/OS/Linux/CentOS8/apache/)
