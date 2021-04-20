# セクション
## ■ Directory
指定したディレクトリ配下に対してアクセス制限などを個別に細かく設定できます。  
  
Document Rootを変更した場合は、そのDocument Rootに対するDirectory設定を忘れてはいけません。
## Options
任意のディレクトリに対して使用できる機能を設定する為のディレクティブです。
|項目|動作説明|
|:---|:---|
|None|何も設定されません。</br>特殊な機能を一切使わない時はこれを指定しましょう。|
|All||
|ExecCGI||
|FollowSymLinks|シンボリックリンクのリンク先をApacheがたどれるようにします。|
|Includes||
|IncludesNOEXEC||
|Indexes|ディレクトリに対するリクエストに対して、DirectoryIndexで指定したファイルが存在しない場合に、ディレクトリ内ファイルの一覧を表示します。|
|MultiViews||
|SymLinksIfOwnerMatch||

## [path] /var/www/html
インデックス機能もシンボリックたどる機能もいらないのでNoneに設定します。
```
<Directory "/var/www/html">
    Options None
    AllowOverride None
    Require all granted
</Directory>
```

## ■ IfModule
## [module] alias_module
### ScriptAlias
指定されたcgi-binディレクトリでCGIプログラムが実行できるように設定できます。  
CGIエイリアスが不要なら無効化します。
```
<IfModule alias_module>
    #ScriptAlias /cgi-bin/ "/var/www/cgi-bin/"
</IfModule>
```
## [module] log_config_module
### LogFormat & CustomLog
ログフォーマットを変更できます。  
デフォルトだとわかりにくいので出力先を`/var/log/httpd/access_log`へ変更します。
```
<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %t %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    CustomLog "/var/log/httpd/access_log" combined
</IfModule>
```
## [module] dir_module
### DirectoryIndex
ディレクトリにファイル指定無しのアクセスがあった場合に、どのファイルを表示するかを設定します。  
例えば、`http://192.168.137.1/`はファイルを指定していませんが、この設定を入れてアクセスするとindex.htmlが表示されます。
```
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>
```
## [module] mime_module
|項目|動作説明|
|:---|:---|
|AddType||
|AddHandler||
|AddEncoding||
|AddOutputFilter||

### AddType
MIMEタイプを設定します。  
html形式のファイル内でPHPの実行を有効にする場合は以下のように設定します。  
```
<IfModule mime_module>
    AddType application/x-httpd-php .php
</IfModule>
```
## [module] mod_expires.c
レスポンスのHTTPヘッダに、`Expires`や`Cache-Control`を付けることでブラウザにキャッシュすることができます。
```
ExpiresDefault "<base> [plus] {<num> <type>}*"
ExpiresByType type/encoding "<base> [plus] {<num> <type>}*"
```
### \<base\>
|項目|動作説明|
|:---|:---|
|access|アクセスしてからの時間を指定|
|modification|ファイルの更新日時から時間を指定する|

### \<type\>
|項目|動作説明|
|:---|:---|
|years|一年間単位|
|months|一ヶ月単位|
|weeks|一週間単位|
|days|一日単位|
|hours|一時間単位|
|minutes|一分単位|
|seconds|一秒単位|

以下の例は、現在時間から1年間キャッシュさせるヘッダを生成してくれます。
### 特定のファイルに対して適用
拡張子が`.html`のファイルを1年間キャッシュを行います。
```
<ifModule mod_expires.c>
  ExpiresActive On
  <FilesMatch "\.html$">
    ExpiresDefault "access plus 1 year"
  </FilesMatch>
</ifModule>
```
### 特定のファイル形式に対して適用
指定のContent-typeによってキャッシュを行います。
```
<ifModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/png  "access plus 1 year"
  ExpiresByType image/jpeg "access plus 1 year"
  ExpiresByType image/gif  "access plus 1 year"
</ifModule>
```
