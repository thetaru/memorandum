# apache
|パッケージ|バージョン|
|:---|:---|
|apache|2.4|

## 設定項目
### Listen
Apacheのリッスンポートを指定します。  
デフォルトでは80番のみですが、SSLサーバ証明書を使用する場合は443番をリッスンさせます。
```
Listen 80
Listen 443
```
### ServerAdmin
連絡用メールアドレスの設定です。  
エラーページに遷移した際に、問い合わせ先として設定したメールアドレスが表示されます。  
つかわないのでコメントしてしまいます。
```
#ServerAdmin root@localhost
```
### ServerName
apacheサーバ自身のホスト名(FQDN)を指定します。
```
#ServerName www.example.com:80
ServerName <hostname>
```
### DocumentRoot
ルートディレクトリを指定します。  
大体の場合デフォルトのままです。
```
DocumentRoot "/var/www/html"
```
### Log
デフォルトだとわかりにくいので出力先を`/var/log/httpd/error_log`へ変更します。
```
#ErrorLog "logs/error_log"
Errorlog "/var/log/httpd/error_log"
```
### AccessLog
ログフォーマットを変更できます。
### DirectoryIndex
ディレクトリにファイル指定無しのアクセスがあった場合に、どのファイルを表示するかを設定します。  
サーバの情報やapacheの情報を漏らしたくないので空の`index.html`を作ってしまいましょう。
```
DirectoryIndex index.html
```
### mime
html形式のファイル内でPHPの実行を有効にする場合は設定します。  
※ mime_moduleのロードが必要
```
AddType application/x-httpd-php .php
```
### Directory
指定したディレクトリ配下に対してアクセス制限などを個別に細かく設定できる。  
Document Rootを変更した場合は、そのDocument Rootに対するDirectory設定を忘れないようにします。
```
<Directory "/var/www/htdocs">

</Directory
```
### Directory - Options
#### Indexs
ディレクトリリスティング(ブラウザからディレクトリ情報が筒抜けになる)を無効化します。
#### FollowSymLinks
シンボリックリンク先をApacheが見れるようになります。
### CGI
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
