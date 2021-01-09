# NATAS9

- Username: natas8
- Password: DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe
- URL: http://natas8.natas.labs.overthewire.org

```
$ curl -u natas8:DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe http://natas8.natas.labs.overthewire.org
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
<script>var wechallinfo = { "level": "natas8", "pass": "DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe" };</script></head>
<body>
<h1>natas8</h1>
<div id="content">


<form method=post>
Input secret: <input name=secret><br>
<input type=submit name=submit>
</form>

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
ブラウザで`http://natas8:DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe@natas8.natas.labs.overthewire.org/index-source.html`にアクセスします。
```html
<?

$encodedSecret = "3d3d516343746d4d6d6c315669563362";

function encodeSecret($secret) {
    return bin2hex(strrev(base64_encode($secret)));
}

if(array_key_exists("submit", $_POST)) {
    if(encodeSecret($_POST['secret']) == $encodedSecret) {
    print "Access granted. The password for natas9 is <censored>";
    } else {
    print "Wrong secret";
    }
}
?>
```
コードを見ると、
```
base64_encode → srtrev → bin2hex
```
としているので`$encodedSecret`に対して逆のことをやればいい。  
1. 16進数を2進数に変換
2. 文字列を逆順に
3. MIME base64方式でデコード
```
$ echo "3d3d516343746d4d6d6c315669563362" | xxd -ps -r | rev | base64 -d
```
```
oubWYf2kBq
```
デコードされた`$emcpdedSecret`を得ることができました。
```
$ curl -u natas8:DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe \
       -d "secret=oubWYf2kBq&submit=Submit" \
           http://natas8.natas.labs.overthewire.org
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
<script>var wechallinfo = { "level": "natas8", "pass": "DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe" };</script></head>
<body>
<h1>natas8</h1>
<div id="content">

Access granted. The password for natas9 is W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl
<form method=post>
Input secret: <input name=secret><br>
<input type=submit name=submit>
</form>

<div id="viewsource"><a href="index-source.html">View sourcecode</a></div>
</div>
</body>
</html>
```
これでpassword(`W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl`)を得ることができました。
