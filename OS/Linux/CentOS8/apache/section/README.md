# セクション
## ■ Directory
指定したディレクトリ配下に対してアクセス制限などを個別に細かく設定できる。  
Document Rootを変更した場合は、そのDocument Rootに対するDirectory設定を忘れてはいけません。
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
## ■ IfModule
### [module] log_config_module
ログフォーマットを変更できます。  
デフォルトだとわかりにくいので出力先を`/var/log/httpd/access_log`へ変更します。
```
<IfModule log_config_module>
    LogFormat "%h %l %u %t \"%r\" %t %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    CustomLog "/var/log/httpd/access_log" combined
</IfModule>
```
